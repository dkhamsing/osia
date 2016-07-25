//
//  Parser.m
//  OSIA
//
//  Created by dkhamsing on 7/25/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import "Parser.h"

#import "Data.h"

static NSString * const jsonUrlString = @"https://raw.githubusercontent.com/dkhamsing/open-source-ios-apps/master/contents.json";

static NSString * const kArchive = @"archive";

@implementation Parser

- (instancetype)init;
{
    self = [super init];
    if (!self)
        nil;
    
    [self setup];
    
    return self;
}

- (void)getLatestDataWithCompletion:(void (^)(Data *, NSError *))completion;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:jsonUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable sessionError) {
        if (completion) {
            if (sessionError) {
                completion(self.data, sessionError);
                return ;
            }
            
            [self parseJsonFromData:data completion:^(NSDictionary *json, NSError *parseError) {
                if (parseError) {
                    completion(self.data, parseError);
                    return;
                }
                
                Data *data = [self processContentsJson:json];
                completion(data, nil);
            }];
        }
    }];
    [task resume];
}

#pragma mark Private

- (void)setup;
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"contents" ofType:@"json"];
    if (fileName) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
        [self parseJsonFromData:data completion:^(NSDictionary *json, NSError *error) {
            if (error) {
                NSLog(@"json parse error: %@", error.localizedDescription);
            }
            else {
                self.data = [self processContentsJson:json];
            }
        }];
    }
}

- (void)parseJsonFromData:(NSData *)data completion:(void(^)(NSDictionary *json, NSError *error))completion;
{
    NSError *parseError;
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    
    if (completion) {
        completion(parsed?:nil, parseError?:nil);
    }
}

- (id)processContentsJson:(NSDictionary *)json;
{
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *subCategories = [[NSMutableDictionary alloc] init];
    
    Data *main = [[Data alloc] init];
    main.name = @"Open-Source iOS Apps";
    main.categoryId = @"root";
    
    NSArray *categories = json[@"categories"];
    [categories enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *categoryId = obj[@"id"];
        NSString *name = obj[@"title"];
        
        // escape markdown link
        if ([name containsString:@"["] &&
            [name containsString:@"]("]
            ) {
            NSInteger start = [name rangeOfString:@"["].location + 1;
            NSInteger end = [name rangeOfString:@"]("].location - 1;
            
            NSRange range = NSMakeRange(start, end);
            NSString *substring = [name substringWithRange:range];
            
            name = substring;
        }
        
        NSString *parent = obj[@"parent"];
        if (!parent) {
            Data *data = [Data new];
            
            data.name = name;
            data.categoryId = categoryId;
            
            [main.subCategories addObject:data];
            
            list[categoryId] = data;
        }
        else {
            Data *data = list[parent];
            
            if (data) {
                Data *subCategory = [Data new];
                subCategory.name = name;
                subCategory.categoryId = categoryId;
                
                [data.subCategories addObject:subCategory];
                
                subCategories[categoryId] = parent;
                
                list[parent] = data;
            }
        }
    }];
    
    NSArray *apps = json[@"projects"];
    [apps enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tags = obj[@"tags"];
        
        // normalize category array
        id category = obj[@"category"];
        if ([category isKindOfClass:[NSString class]])
            category = @[category];
        NSArray *normalized = category;
        
        [normalized enumerateObjectsUsingBlock:^(NSString *  _Nonnull cat, NSUInteger idx, BOOL * _Nonnull stop) {
            Data *data = list[cat];
            if (data) {
                if (![tags containsObject:kArchive])
                    [data.apps addObject:obj];
                
                list[cat] = data;
            }
            else {
                NSString *lookup = subCategories[cat];
                Data *data = list[lookup];
                
                [data.subCategories enumerateObjectsUsingBlock:^(Data *  _Nonnull sub, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([sub.categoryId isEqualToString:cat] &&
                        ![tags containsObject:kArchive])
                        [sub.apps addObject:obj];
                }];
                
                list[lookup] = data;
            }
        }];
    }];
    
    return main;
}

@end
