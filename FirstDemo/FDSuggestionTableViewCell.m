//
//  FDSuggestionTableViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/3.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSuggestionTableViewCell.h"
#import "Masonry/Masonry.h"
#import "FDSuggestionCollectionViewCell.h"
#import "FDConstants.h"

static NSString * const CellIndentifier = @"FDSuggestionCollectionViewCell";

@interface FDSuggestionTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation FDSuggestionTableViewCell

- (void)drawRect:(CGRect)rect {
    UIBezierPath *plusPath = [UIBezierPath bezierPath];
    plusPath.lineWidth = 1;
    [plusPath moveToPoint:CGPointMake(15, 147/2)];
    [plusPath addLineToPoint:CGPointMake(SCREEN_WIDTH-15, 147/2)];
    [plusPath moveToPoint:CGPointMake(SCREEN_WIDTH/2, 0)];
    [plusPath addLineToPoint:CGPointMake(SCREEN_WIDTH/2, 147)];
    [[[UIColor whiteColor] colorWithAlphaComponent:0.2] setStroke];
    [plusPath stroke];
}

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
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // TODO: flowlayout tweak
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2, 147/2);      
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
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
    [_collectionView registerClass:[FDSuggestionCollectionViewCell class] forCellWithReuseIdentifier:CellIndentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
    FDSuggestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    
    // id item = _items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    // configure cells there?
}

@end
