//
//  AppCoordinator.m
//  OSIA
//
//  Created by dkhamsing on 12/31/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//


#import "AppCoordinator.h"

// Controllers
#import "DataViewController.h"
#import "ScreenshotsController.h"

// Misc
#import "Parser.h"
@import SafariServices;

@interface AppCoordinator ()

@property (nonatomic, strong) NSURL *appStoreLink;

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
{
    self = [super init];
    if (!self) return nil;
    
    _navigationController = navigationController;
    
    return self;
}

- (void)start;
{
    Parser *parser = [[Parser alloc] init];
    DataViewController *controller = [[DataViewController alloc] init];
    [parser getLatestDataWithCompletion:^(Data *data, NSError *error) {
        controller.data = data;
        if (error)
            NSLog(@"get data error: %@", error);
    }];
    
    __weak AppCoordinator *weakSelf = self;
    controller.didSelectApp = ^(NSDictionary *app) {
        [weakSelf showApp:app];
    };
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark Private

- (void)openAppStoreLink;
{
    [[UIApplication sharedApplication] openURL:self.appStoreLink];
}

- (void)showApp:(NSDictionary *)app;
{
    NSString *key = @"itunes";
    NSURL *appStoreLink = nil;
    if ([app.allKeys containsObject:key]) {
        appStoreLink = [NSURL URLWithString:app[@"itunes"]];
    }
    self.appStoreLink = appStoreLink;
    
    NSString *source = app[@"source"];
    NSURL *url = [NSURL URLWithString:source];
    
    NSString *screenshotsKey = @"screenshots";
    NSArray *screenshots = app[screenshotsKey];
    BOOL hasScreenshots = screenshots.count>0;
    if (hasScreenshots) {
        ScreenshotsController *controller = [[ScreenshotsController alloc] init];
        controller.screenshots = screenshots;
        controller.hideLeftButton = appStoreLink == nil;
        controller.sourceTitle = [url.absoluteString.lowercaseString containsString:@"//github.com"] ? @"GitHub" : @"Source";
        controller.didSelectAppStore = ^() {
            SFSafariViewController *s = [[SFSafariViewController alloc] initWithURL:appStoreLink];
            [self.navigationController pushViewController:s animated:YES];
        };
        controller.didSelectSource = ^() {
            SFSafariViewController *s = [[SFSafariViewController alloc] initWithURL:url];
            [self.navigationController pushViewController:s animated:YES];            
        };
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
        safariViewController.title = app[@"title"];
        
        if (appStoreLink)
            safariViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"App Store" style:UIBarButtonItemStylePlain target:self action:@selector(openAppStoreLink)];
        
        [self.navigationController pushViewController:safariViewController animated:YES];
    }
}

@end
