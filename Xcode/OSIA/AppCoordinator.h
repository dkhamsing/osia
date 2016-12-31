//
//  AppCoordinator.h
//  OSIA
//
//  Created by dkhamsing on 12/31/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

/* Coordinates the app. */
@interface AppCoordinator : NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)start;

@end
