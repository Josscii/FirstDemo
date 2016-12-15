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

static NSString * const CellIndentifier = @"FDTodayWeatherCollectionViewCell";

@interface FDTodayWeatherTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) NSDictionary *sun;

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
    return _items.count;
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
    
    id item = _items[indexPath.item];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@时", item[@"h"]];
    cell.tempLabel.text = [FDUtils tempWithNumber: item[@"tm"]];
    
    NSNumber *hour = item[@"h"];
    NSNumber *sr = [FDUtils hourOfTime: _sun[@"sr"]];
    NSNumber *ss = [FDUtils hourOfTime: _sun[@"ss"]];
    
    if ([hour integerValue] >= [sr integerValue] && [hour integerValue] <= [ss integerValue]) {
        cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", item[@"wt"]]];
    } else {
        if ([UIImage imageNamed: [NSString stringWithFormat:@"nn%@", item[@"wt"]]] == nil) {
            cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", item[@"wt"]]];
        } else {
            cell.weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", item[@"wt"]]];
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
    _items = data[@"fch"];
    _sun = data[@"sun"];
    [self.collectionView reloadData];
}

@end
