//
//  TodayViewController.m
//  widget2
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetDayCollectionViewCell.h"
#import "FDUtils.h"
#import "Masonry.h"
#import "UIColor+FDColor.h"
#import "WidgetCalendarModel.h"

@interface TodayViewController () <NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, copy) NSArray *calendarModels;

@property (nonatomic, strong) UIView *separator;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _calendarModels = [FDUtils getAllCalendarModels];
    
    [self setupView];
}

- (void)setupView {
    
    // dateLabel
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor wd_blackColor];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:_dateLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(13);
    }];
    
    // separator
    _separator = [[UIView alloc] init];
    _separator.backgroundColor = [[UIColor wd_blackColor] colorWithAlphaComponent:0.2];
    
    [self.view addSubview:_separator];
    
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(_dateLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(0.5);
    }];
    
    // hreader
    NSArray *weakday = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    NSArray<NSNumber *> *xs = @[@(25.5), @(75), @(125), @(174.5), @(224), @(275), @(327)];
    
    UIView *header = [[UIView alloc] init];
    
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xs[i].integerValue, 10, 0, 0)];
        label.textColor = [[UIColor wd_blackColor] colorWithAlphaComponent:0.6];
        label.font = [UIFont systemFontOfSize:10];
        label.text = weakday[i];
        [label sizeToFit];
        [header addSubview:label];
    }
    
    [self.view addSubview:header];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.top.equalTo(_separator.mas_bottom);
    }];
    
    // collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(45, 45);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 15, 5);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WidgetDayCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(240);
        make.top.equalTo(header.mas_bottom);
    }];
    
    // collectionView1
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout1.itemSize = CGSizeMake(45, 45);
    flowLayout1.sectionInset = UIEdgeInsetsMake(0, 5, 15, 5);
    flowLayout1.minimumLineSpacing = 0;
    flowLayout1.minimumInteritemSpacing = 0;
    
    _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout1];
    _collectionView1.delegate = self;
    _collectionView1.dataSource = self;
    _collectionView1.showsVerticalScrollIndicator = NO;
    _collectionView1.showsHorizontalScrollIndicator = NO;
    _collectionView1.backgroundColor = [UIColor clearColor];
    [_collectionView1 registerClass:[WidgetDayCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView1];
    
    [_collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.top.equalTo(header.mas_bottom);
    }];
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    _dateLabel.text = @"9月26日  周一  第48周  农历八月廿六";
}

#pragma mark -
#pragma mark - delegate 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView isEqual:_collectionView1]) {
        return 7;
    }
    
    return _calendarModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WidgetDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    WidgetCalendarModel *model = nil;
    
    if ([collectionView isEqual:_collectionView]) {
        model = _calendarModels[indexPath.item];
    } else {
        model = _calendarModels[indexPath.item + 28];
    }
    
    [cell configureCellWithData:model index: indexPath.item];
    
    return cell;
}

#pragma mark -
#pragma mark - widget

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _collectionView1.hidden = NO;
            _collectionView.hidden = YES;
            
            [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(8.5);
            }];
            
            [_separator mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(7);
            }];
        });
    } else {
        self.preferredContentSize = CGSizeMake(0, 313.5);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _collectionView1.hidden = YES;
            _collectionView.hidden = NO;
            
            [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(13);
            }];
            
            [_separator mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(13);
            }];
        });
    }
}

@end
