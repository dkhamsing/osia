//
//  Data.h
//  OSIA
//
//  Created by dkhamsing on 7/22/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Data model. */
@interface Data : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *count; // computed value

@property (nonatomic, strong) NSString *categoryId;

@property (nonatomic, strong) NSMutableArray *subCategories;

@property (nonatomic, strong) NSMutableArray *apps;

@end
