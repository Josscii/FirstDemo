//
//  WidgetTableViewCell4.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetTableViewCell4.h"
#import "WidgetCollectionViewCell.h"
#import "Masonry.h"
#import "FDForecastItemDate.h"
#import "FDUtils.h"

@interface WidgetTableViewCell4 () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger tomorrowIndex;

@end

@implementation WidgetTableViewCell4

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, 93);
    flowLayout.minimumLineSpacing = 94.5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[WidgetCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WidgetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    FDForecastItemDate *item = _city.fcd[_tomorrowIndex+indexPath.item];
    
    if (indexPath.item == 0) {
        cell.dateLabel.text = @"明天";
    } else if (indexPath.item == 1) {
        cell.dateLabel.text = @"后天";
        [cell alphaView];
    } else {
        cell.dateLabel.text = [FDUtils weakdayWithDate:item.date];
        [cell alphaView];
    }
    
    cell.weatherImageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", item.weatherType]];
    cell.tempLabel.text = [NSString stringWithFormat:@"%@/%@°", item.tempLow, item.tempHigh];
    
    return cell;
}

- (void)setCity:(FDCity *)city {
    _city = city;
    
    for (FDForecastItemDate *date in _city.fcd) {
        if ([date.date isEqualToString:_city.curr.date]) {
            _tomorrowIndex = [_city.fcd indexOfObject:date] + 1;
            break;
        }
    }
    
    [_collectionView reloadData];
}

@end
