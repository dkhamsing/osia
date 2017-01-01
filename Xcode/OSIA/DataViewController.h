//
//  DataViewController.h
//  OSIA
//
//  Created by dkhamsing on 7/22/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Data;

/* Display OSIA data. */
@interface DataViewController : UIViewController

@property (nonatomic, strong) Data *data;

@property (nonatomic, copy) void (^didSelectApp)(NSDictionary *app);

@end
