//
//  FDForecastWeatherTableViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDForecastWeatherTableViewCell.h"
#import "Masonry/Masonry.h"
#import "FDForecastWeatherCollectionViewCell.h"
#import "FDChartView.h"
#import "FDConstants.h"
#import "FDUtils.h"
#import "FDCity.h"
#import "FDForecastItemDate.h"

static NSString * const CellIndentifier = @"FDForecastWeatherCollectionViewCell";

@interface FDForecastWeatherTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FDChartView *highChartView;
@property (nonatomic, strong) FDChartView *lowChartView;

@property (nonatomic, strong) FDCity *city;

@end

@implementation FDForecastWeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureLayout];
    }
    return self;
}

- (void)configureLayout {
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // TODO: flowlayout tweak
    flowLayout.itemSize = CGSizeMake(50, 101);
    flowLayout.sectionInset = UIEdgeInsetsMake(-121, 15, 0, 15);
    flowLayout.minimumInteritemSpacing = CGFLOAT_MAX;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsSelection = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[FDForecastWeatherCollectionViewCell class] forCellWithReuseIdentifier:CellIndentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _city.fcd.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
    FDForecastWeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.alpha = 0.6;
    } else {
        cell.alpha = 1;
    }
    
    FDForecastItemDate *item = _city.fcd[indexPath.item];
    
    NSString *d = item.date;
    NSNumber *wt = item.weatherType;
    
    cell.weakdayLabel.text = [FDUtils weakdayWithDate:d];
    cell.dateLabel.text = [FDUtils dateWithString:d];
    cell.tempLabel.text = [FDUtils weatherType:wt.integerValue];
    cell.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"nd%@", wt]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    // configure cells there?
}

- (void)feedCellWithData:(id)data {
    _city = data;
    [self.collectionView reloadData];
    [self reloadData];
}

- (void)reloadData {
    NSMutableArray *highValues = [@[] mutableCopy];
    NSMutableArray *highTitles = [@[] mutableCopy];
    
    NSMutableArray *lowValues = [@[] mutableCopy];
    NSMutableArray *lowTitles = [@[] mutableCopy];
    
    for (FDForecastItemDate *item in _city.fcd) {
        NSNumber *th = item.tempHigh;
        NSNumber *tl = item.tempLow;
        
        [highValues addObject:th];
        [highTitles addObject:[FDUtils tempWithNumber:th]];
        
        [lowValues addObject:tl];
        [lowTitles addObject:[FDUtils tempWithNumber:tl]];
    }
    
    [_highChartView removeFromSuperview];
    [_lowChartView removeFromSuperview];
        
    // chartview
    _highChartView = [[FDChartView alloc] initWithValues:[highValues copy]
                                                  titles:[highTitles copy]
                                                  startY:70];
    
    [_collectionView addSubview:_highChartView];
    [_highChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_collectionView);
        make.bottom.equalTo(self.contentView);
    }];
    
    _lowChartView = [[FDChartView alloc] initWithValues:[lowValues copy]
                                                 titles:[lowTitles copy]
                                                 startY: 90];
    _lowChartView.position = FDChartViewTextPositionBottom;
    [_collectionView addSubview:_lowChartView];
    [_lowChartView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(_collectionView);
    make.bottom.equalTo(self.contentView);
   }];
}

@end
