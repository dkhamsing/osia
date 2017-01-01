//
//  ScreenshotsController.m
//  OSIA
//
//  Created by dkhamsing on 11/16/16.
//  Copyright © 2016 dkhamsing. All rights reserved.
//

#import "ScreenshotsController.h"

@interface ScreenshotCell : UICollectionViewCell

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

@implementation ScreenshotCell

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self setup];
    
    return self;
}

- (void)setUrlString:(NSString *)urlString;
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            NSLog(@"error: %@", error);                    
        else
            self.imageView.image = [UIImage imageWithData:data];
    }];
    [task resume];
}

- (void)setup;
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self.contentView addSubview:self.imageView];
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end

@interface ScreenshotsController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ScreenshotsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.leftButton  = [[UIButton alloc] init];
    self.rightButton = [[UIButton alloc] init];

    [self setup];
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self render];
}

#pragma mark Private

- (void)render;
{
    NSString *title = [NSString stringWithFormat:@"%@ Screenshot%@",
                       @(self.screenshots.count),
                       self.screenshots.count==1?@"":@"s"
                       ];
    self.title = title;
    
    [self.collectionView reloadData];
    
    self.leftButton.hidden = self.hideLeftButton;
    
    [self.rightButton setTitle:self.sourceTitle forState:UIControlStateNormal];
}

static NSString * const kCollectionId = @"kCollectionId";

- (void)setup;
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[ScreenshotCell class] forCellWithReuseIdentifier:kCollectionId];
    
    // buttons
    UIView *container = [[UIView alloc] init];
        
    {
        [self.view addSubview:container];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{@"container":container};
        NSDictionary *metrics = @{ @"h": @50 };
        NSArray *formats = @[
                             @"|[container]|",
                             @"V:[container(h)]|"
                             ];
        [formats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:obj options:kNilOptions metrics:metrics views:views];
            [self.view addConstraints:constraints];
        }];
    }
    
    [self.leftButton setTitle:@"App Store"  forState:UIControlStateNormal];
    
    {
        NSDictionary *views = @{
                                @"left":self.leftButton,
                                @"right":self.rightButton
                                };
        NSDictionary *metrics = nil;
        [views.allValues enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [container addSubview:obj];
            obj.translatesAutoresizingMaskIntoConstraints = NO;
        }];        
        NSArray *formats = @[
                             @"|[left][right(left)]|",
                             @"V:|[left]|",
                             @"V:|[right]|"
                             ];
        [formats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:obj options:kNilOptions metrics:metrics views:views];
            [container addConstraints:constraints];
        }];
    }
    
    [self.leftButton  addTarget:self action:@selector(actionLeft)  forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(actionRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionLeft;
{
    if (self.didSelectAppStore)
        self.didSelectAppStore();
}

- (void)actionRight;
{
    if (self.didSelectSource)
        self.didSelectSource();
}

#pragma mark Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.screenshots.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ScreenshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionId forIndexPath:indexPath];
    cell.urlString = self.screenshots[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = self.view.bounds.size;
    size.height -= 170;
    
    return size;
}

@end
