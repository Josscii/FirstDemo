//
//  FDManageCityViewController.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDManageCityViewController.h"
#import "UIColor+FDColor.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"
#import "UILabel+FDLabel.h"
#import "FDEditCityFlowLayout.h"
#import "FDEditCityCollectionViewCell.h"
#import "FdAddCotyCollectionViewCell.h"
#import "FDSelectCityViewController.h"
#import "FDUtils.h"

static NSString * const FDEditCityCollectionViewCellIdentifier = @"FDEditCityCollectionViewCell";
static NSString * const FdAddCotyCollectionViewCellIdentifier = @"FdAddCotyCollectionViewCell";

@interface FDManageCityViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FDEditCityCollectionViewCellDelegate, FDEditCityDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FDEditCityFlowLayout *flowLayout;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) NSMutableArray<FDCity *> *cities;

@property (nonatomic, strong) NSIndexPath *indexPathForReordering;
@property (nonatomic, strong) UIView *snapshotView;

@end

@implementation FDManageCityViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
//    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
//    [_collectionView addGestureRecognizer:_longPressGesture];
    
    _cities = [[FDUtils getAllSeletedCities] mutableCopy];
    [_collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _cities = [[FDUtils getAllSeletedCities] mutableCopy];
    [[NSUserDefaults standardUserDefaults] setInteger:_cities.count forKey:CURRENTCITYCOUNT];
    [_collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [FDUtils saveAllSeletedCities:[_cities copy]];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor backgroundColor];
    
    // bg
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-bg-img"]];
    [self.view addSubview:bgimageView];
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(135.0f);
    }];
    
    // collectionView
    _flowLayout = [[FDEditCityFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 - 5) / 3, 129);
    _flowLayout.sectionInset = UIEdgeInsetsMake(64, 15, 0, 5);
    _flowLayout.editCityDelegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[FDEditCityCollectionViewCell class] forCellWithReuseIdentifier:FDEditCityCollectionViewCellIdentifier];
    [_collectionView registerClass:[FdAddCotyCollectionViewCell class] forCellWithReuseIdentifier:FdAddCotyCollectionViewCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];
    
    // navView
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:navView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.tintColor = [UIColor whiteColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(15);
        make.top.equalTo(navView).offset(32);
    }];
    
    UILabel *titleLabel = [UILabel lowShadowLabelWithFontName:PFSCM FontSize:17];
    titleLabel.text = @"城市管理";
    
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView).offset(32);
        make.centerX.equalTo(navView);
    }];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _editButton.tintColor = [UIColor whiteColor];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(editCity:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:_editButton];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView).offset(-15);
        make.top.equalTo(navView).offset(32);
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:EDITINGCITY];
    // pre logic
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"defaultCityIndex"];
}

#pragma mark -
#pragma mark - actions

- (void)editCity:(id)sender {
    if ([_editButton.titleLabel.text isEqualToString:@"编辑"]) {
        [_editButton setTitle:@"完成" forState:UIControlStateNormal];
        _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 - 5) / 3, 155);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EDITINGCITY];
        
        [_flowLayout invalidateLayout];
    } else {
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 15 - 5) / 3, 129);
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:EDITINGCITY];
        
        // pre logic
        //NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultCityIndex"];
        //[_cities exchangeObjectAtIndex:defaultIndex withObjectAtIndex:0];
        //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"defaultCityIndex"];
        
        [_flowLayout invalidateLayout];
    }
}

#pragma mark -
#pragma mark - FDEditCityCollectionViewCellDelegate

- (void)deleteCell:(UICollectionViewCell *)cell {
    
    NSInteger deleteIndex = [_collectionView indexPathForCell:cell].item;
    NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULTCIYTINDEX];
    
    if (defaultIndex > deleteIndex) {
        [[NSUserDefaults standardUserDefaults] setInteger:defaultIndex-1 forKey:DEFAULTCIYTINDEX];
    }
    
    [_cities removeObjectAtIndex:deleteIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:_cities.count forKey:CURRENTCITYCOUNT];
    [_collectionView deleteItemsAtIndexPaths: @[[NSIndexPath indexPathForItem:deleteIndex inSection:0]]];
    
}

#pragma mark - 
#pragma mark - collection view delegate and datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cities.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _cities.count) {
        FdAddCotyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FdAddCotyCollectionViewCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    FDEditCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FDEditCityCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    FDCity *city = _cities[indexPath.item];
    
    cell.cityLabel.text = city.cityName;
    
    if (!city.saveTime) {
        [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
            [city configureWihtDictionary:weatherData];
            
            [cell configreCellWithData:city];
        }];
    } else {
        if (city.isExpired) {
            [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
                [city configureWihtDictionary:weatherData];
                
                [cell configreCellWithData:city];
            }];
        } else {
            [cell configreCellWithData:city];
        }
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _cities.count) {
        FDSelectCityViewController *selectViewController = [[FDSelectCityViewController alloc] init];
        [self.navigationController pushViewController:selectViewController animated:YES];
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:EDITINGCITY]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setDouble:indexPath.item forKey:SELECTEDINDEX];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - collection view reodering

- (void)fd_collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    FDCity *model = _cities[sourceIndexPath.item];
    [_cities removeObjectAtIndex:sourceIndexPath.item];
    [_cities insertObject:model atIndex:destinationIndexPath.item];
    
    // not exchange !!!
    // [_cities exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    
    // current logic of reranging cells
    NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:DEFAULTCIYTINDEX];
    if (sourceIndexPath.item == defaultIndex) {
        [[NSUserDefaults standardUserDefaults] setInteger:destinationIndexPath.item forKey:DEFAULTCIYTINDEX];
    } else {
        if (sourceIndexPath.item > defaultIndex) {
            if (destinationIndexPath.item > defaultIndex) {
                return;
            } else {
                [[NSUserDefaults standardUserDefaults] setInteger:defaultIndex+1 forKey:DEFAULTCIYTINDEX];
            }
        } else {
            if (destinationIndexPath.item < defaultIndex) {
                return;
            } else {
                [[NSUserDefaults standardUserDefaults] setInteger:defaultIndex-1 forKey:DEFAULTCIYTINDEX];
            }
        }
    }
}

- (BOOL)fd_collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _cities.count) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark - others

- (void)popViewController {
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:SELECTEDINDEX];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
