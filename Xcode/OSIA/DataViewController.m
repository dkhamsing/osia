//
//  DataViewController.m
//  OSIA
//
//  Created by dkhamsing on 7/22/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import "DataViewController.h"

#import "Data.h"
@import SafariServices;

@interface DataViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DataViewController

static NSString * const dataCellId = @"dataCellId";

static NSString * const itemCellId = @"itemCellId";

static NSString * const kSwiftMarker = @" Swift ";

/*
- (instancetype)initWithData:(Data *)data;
{
    self = [super init];
    if (!self)
        return nil;
    
    self.data = data;
    
    return self;
}
*/

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self setup];
}

- (void)setData:(Data *)data;
{
    _data = data;
    [self reload];
}

- (void)reload;
{
    self.title = self.data.name;
    
    self.dataSource = ({
        NSMutableArray *list = [NSMutableArray new];
        
        [self.data.subCategories enumerateObjectsUsingBlock:^(Data *  _Nonnull sub, NSUInteger idx, BOOL * _Nonnull stop) {
            [list addObject:sub];
        }];
        
        NSMutableArray *apps = [NSMutableArray new];
        [self.data.apps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [apps addObject:obj];
        }];
        
        NSArray *sorted = [apps sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *  _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
            NSString *title1 = obj1[@"title"];
            NSString *title2 = obj2[@"title"];
            return [title1.lowercaseString compare:title2.lowercaseString];
        }];
        
        [list addObjectsFromArray:sorted];
        list;
    });
    
    [self.tableView reloadData];
}

- (void)setup;
{
    self.navigationController.navigationBar.barTintColor = self.swiftColor;
    
    UIColor *color = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    self.navigationController.navigationBar.tintColor = color;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (UIColor *)swiftColor;
{
    UIColor *swiftColor = [UIColor colorWithRed:230/255.f green:78/255.f blue:54/255.f alpha:1];
    return swiftColor;
}

#pragma mark Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id item = self.dataSource[indexPath.row];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellId];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:itemCellId];
        
        cell.textLabel.text = ({
            NSString *title = item[@"title"];
            title;
        });
        
        cell.detailTextLabel.attributedText = ({
            NSString *description = item[@"description"];
            NSArray *tags = item[@"tags"];
            if ([tags containsObject:@"swift"]) {
                NSString *swift = [NSString stringWithFormat:@" %@", kSwiftMarker];
                description = [description stringByAppendingString:swift];
            }
            
            NSMutableAttributedString *attributed = description?
            [[NSMutableAttributedString alloc] initWithString:description]:
            nil;
            
            if (attributed) {
                UIColor *swiftColor = self.swiftColor;
                NSDictionary *attributes = @{
                                             NSBackgroundColorAttributeName:swiftColor,
                                             NSForegroundColorAttributeName:[UIColor whiteColor]};
                NSRange range = [description rangeOfString:kSwiftMarker];
                [attributed addAttributes:attributes range:range];
            }
            
            attributed;
        });
        
        return cell;
    }
    
    // Data
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:dataCellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Data *data = item;
    
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.count.stringValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id item = self.dataSource[indexPath.row];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSString *source = item[@"source"];
        NSURL *url = [NSURL URLWithString:source];
        
        SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:url];
        safariController.title = item[@"title"];

        [self.navigationController pushViewController:safariController animated:YES];
        return;
    }
    
    // Data
    DataViewController *controller = [[DataViewController alloc] init];
    controller.data = item;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
