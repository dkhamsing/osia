//
//  DataViewController.m
//  OSIA
//
//  Created by dkhamsing on 7/22/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import "DataViewController.h"

// Models
#import "Data.h"

@interface DataViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DataViewController

static NSString * const dataCellId = @"dataCellId";

static NSString * const itemCellId = @"itemCellId";

static NSString * const kAppStoreMarker = @" App Store ";

static NSString * const kCodeMarker = @"`";

static NSString * const kSwiftMarker = @" Swift ";

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [self setup];
}

- (void)setData:(Data *)data;
{
    _data = data;
    [self render];
}

- (void)render;
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

#pragma mark Private

- (NSAttributedString *)attributedStringForItem:(NSDictionary *)item;
{
    NSString *title = item[@"title"];
    
    NSString *description = item[@"description"];
    description = [description stringByReplacingOccurrencesOfString:kCodeMarker withString:@""];
    
    NSString *subtitle = description;
    
    NSArray *tags = item[@"tags"];
    
    BOOL isSwift = [tags containsObject:@"swift"];
    BOOL inAppStore = [item.allKeys containsObject:@"itunes"];
    
    BOOL condition = isSwift || inAppStore;
    if (condition) {
        if (description)
            description = [description stringByAppendingString:@"\n"];
        else
            description = @"";
    }
    
    if (isSwift) {
        NSString *swift = [NSString stringWithFormat:@" %@", kSwiftMarker];
        description = [description stringByAppendingString:swift];
    }
    
    if (inAppStore) {
        NSString *addition = [NSString stringWithFormat:@" %@", kAppStoreMarker];
        description = [description stringByAppendingString:addition];
    }
    
    NSString *text = title;
    if (description)
        text = [title stringByAppendingFormat:@"\n%@", description];
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    
    {
        UIColor *color = self.swiftColor;
        NSDictionary *attributes = @{
                                     NSBackgroundColorAttributeName:color,
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
        NSRange range = [text rangeOfString:kSwiftMarker];
        [attributed addAttributes:attributes range:range];
    }
    
    {
        UIColor *color = [UIColor lightGrayColor];
        NSDictionary *attributes = @{
                                     NSBackgroundColorAttributeName:color,
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
        
        NSRange range = [text rangeOfString:kAppStoreMarker];
        [attributed addAttributes:attributes range:range];
    }
    
    if (description)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        NSDictionary *attributes = @{
                                     NSParagraphStyleAttributeName:style,
                                     NSFontAttributeName:[UIFont systemFontOfSize:12]
                                     };
        NSRange range = [text rangeOfString:description];
        [attributed addAttributes:attributes range:range];
    }
    
    if (subtitle)
    {
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName:[UIColor grayColor]
                                     };
        NSRange range = [text rangeOfString:subtitle];
        [attributed addAttributes:attributes range:range];
    }
    
    return attributed;
}

- (UIColor *)swiftColor;
{
    UIColor *swiftColor = [UIColor colorWithRed:230/255.f green:78/255.f blue:54/255.f alpha:1];
    return swiftColor;
}

#pragma mark Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id item = self.dataSource[indexPath.row];
    
    return  [item isKindOfClass:[NSDictionary class]] ?
    ({
        
        
        CGSize size = self.view.bounds.size;
        size.width -= (20 * 2);
        
        NSAttributedString *attributed = [self attributedStringForItem:item];
        
        CGRect rect = [attributed boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGFloat subtitle = rect.size.height;
        
        CGFloat pad = 15;
        CGFloat total = subtitle + pad * 2;
        total;
    }):
    50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    id item = self.dataSource[indexPath.row];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:itemCellId];
            cell.textLabel.numberOfLines = 0;
        }
        
        cell.textLabel.attributedText = [self attributedStringForItem:item];
        
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
        NSDictionary *app = (NSDictionary *)item;
        if (self.didSelectApp)
            self.didSelectApp(app);
    }
    else {
        DataViewController *controller = [[DataViewController alloc] init];
        controller.data = item;
        controller.didSelectApp = self.didSelectApp;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
