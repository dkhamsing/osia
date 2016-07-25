//
//  Data.m
//  OSIA
//
//  Created by dkhamsing on 7/22/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import "Data.h"

@implementation Data

- (instancetype)init;
{
    self = [super init];
    if (!self)
        return nil;

    [self setup];
    
    return self;
}

- (void)setup;
{
    self.apps = [NSMutableArray new];
    self.subCategories = [NSMutableArray new];
}

- (NSNumber *)count;
{
    __block NSInteger subTotal = 0;
    [self.subCategories enumerateObjectsUsingBlock:^(Data *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        subTotal += obj.apps.count;
    }];
    
    NSInteger total = self.apps.count + subTotal;
    
    return @(total);
}

@end
