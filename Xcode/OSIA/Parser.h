//
//  Parser.h
//  OSIA
//
//  Created by dkhamsing on 7/25/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data;

/* Parse OSIA contents.json file. */
@interface Parser : NSObject

@property (nonatomic, strong) Data *data;

- (void)getLatestDataWithCompletion:(void (^)(Data *, NSError *))completion;

@end
