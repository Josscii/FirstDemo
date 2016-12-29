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
@property (nonatomic, copy) NSArray *calendarModels;

@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) NSInteger todayIndex;

@property (nonatomic, assign) BOOL weekView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _weekView = NO;
    
    _calendarModels = [FDUtils getAllCalendarModels];
    
    /// find the today
    [_calendarModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WidgetCalendarModel *model = obj;
        if (model.isToday) {
            _todayIndex = idx;
            *stop = YES;
        }
    }];
    
    [self setupView];
    
    _dateLabel.text = [FDUtils currentDateInfo];
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
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

#pragma mark -
#pragma mark - delegate 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_weekView) {
        return 7;
    }
    
    return _calendarModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WidgetDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    WidgetCalendarModel *model = nil;
    
    if (!_weekView) {
        model = _calendarModels[indexPath.item];
    } else {
        
        NSInteger offset = floor(_todayIndex/7.0) * 7;
        model = _calendarModels[indexPath.item + offset];
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
        
        _weekView = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_collectionView reloadData];
            
            [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(8.5);
            }];
            
            [_separator mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(7);
            }];
        });
    } else {
        self.preferredContentSize = CGSizeMake(0, 313.5);
        
        _weekView = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
            
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
