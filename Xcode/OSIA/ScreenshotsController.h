//
//  ScreenshotsController.h
//  OSIA
//
//  Created by dkhamsing on 11/16/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Displays screenshots */
@interface ScreenshotsController : UIViewController

@property (nonatomic, copy) void (^didSelectAppStore)();

@property (nonatomic, copy) void (^didSelectSource)();

@property (nonatomic, strong) NSArray *screenshots;

/* Buttons */
@property (nonatomic) BOOL hideLeftButton;

@property (nonatomic, strong) NSString *sourceTitle;

@end
