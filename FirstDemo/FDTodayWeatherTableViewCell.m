//
//  FDTodayWeatherTableViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDTodayWeatherTableViewCell.h"
#import "Masonry/Masonry.h"
#import "FDTodayWeatherCollectionViewCell.h"
#import "FDUtils.h"
#import "FDConstants.h"
#import "FDCity.h"
#import "FDForecastItemHour.h"

static NSString * const CellIndentifier = @"FDTodayWeatherCollectionViewCell";

@interface FDTodayWeatherTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FDCity *city;

@end

@implementation FDTodayWeatherTableViewCell

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
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
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
    [_collectionView registerClass:[FDTodayWeatherCollectionViewCell class] forCellWithReuseIdentifier:CellIndentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _city.fch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
    FDTodayWeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.timeLabel.font = [UIFont fontWithName:PFSCM size:13];
        cell.tempLabel.font = [UIFont fontWithName:SFDB size:13];
    } else {
        cell.timeLabel.font = [UIFont fontWithName:SFDR size:13];
        cell.tempLabel.font = [UIFont fontWithName:SFDR size:13];
    }
    
    FDForecastItemHour *item = _city.fch[indexPath.item];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@时", item.hour];
    cell.tempLabel.text = [FDUtils tempWithNumber: item.temp];
    
    NSNumber *hour = item.hour;
    NSNumber *sr = [FDUtils hourOfTime: _city.sunRiseTime];
    NSNumber *ss = [FDUtils hourOfTime: _city.sunFallTime];
    
    if ([hour integerValue] >= [sr integerValue] && [hour integerValue] <= [ss integerValue]) {
        cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", item.weatherType]];
    } else {
        if ([UIImage imageNamed: [NSString stringWithFormat:@"nn%@", item.weatherType]] == nil) {
            cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", item.weatherType]];
        } else {
            cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", item.weatherType]];
        }
    }
    
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
}

@end
