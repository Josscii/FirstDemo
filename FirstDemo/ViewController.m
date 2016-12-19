
//  ViewController.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "ViewController.h"

#import "FDConstants.h"
#import "FDSwitchCityButton.h"
#import "FDManageCityViewController.h"
#import "UIColor+FDColor.h"
#import "FDMainCollectionViewCell.h"
#import "FDWeatherModel.h"
#import "FDUtils.h"

#import "Masonry/Masonry.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

static NSString * const FDMainCollectionViewCellIdentifier = @"FDMainCollectionViewCellIdentifier";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<FDWeatherModel *> *cities;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) FDSwitchCityButton *switchCityButton;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView];
    
    _firstLoad = YES;
    _cities = [[FDUtils getAllSeletedCities] mutableCopy];
    
    if (_cities.count == 0) {
        _cities = [NSMutableArray array];
        
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setLocationTimeout:6];
        [_locationManager setReGeocodeTimeout:3];
        
        [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            NSString *cityName = [regeocode.district substringToIndex:2];
            NSString *cityCode = [FDUtils codeOfCity:cityName];
            
            FDWeatherModel *current = [[FDWeatherModel alloc] initWithCityCode:cityCode cityName:cityName];
            
            [_cities addObject:current];
            [FDUtils saveAllSeletedCities:[_cities copy]];
            
            [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:LOCATION];
            
            [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
            [_collectionView reloadData];
        }];
    } else {
        [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
        [_collectionView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_firstLoad == YES) {
        _firstLoad = NO;
    } else {
        double selectedIndex = [[NSUserDefaults standardUserDefaults] doubleForKey:SELECTEDINDEX];
        
        _cities = [[FDUtils getAllSeletedCities] mutableCopy];
        _collectionView.contentOffset = CGPointMake(selectedIndex * SCREEN_WIDTH, 0);
        [self reloadDataWithPage:selectedIndex shouldReloadCollectionView:YES];
        
        for (FDWeatherModel *model in _cities) {
            NSLog(@"%@", model.cityCode);
        }
    }
}

- (void)setupView {
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor backgroundColor];
    
    // bg
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-bg-img"]];
    [self.view addSubview:bgimageView];
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(135.0f);
    }];
    
    // collectionView
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = [UIScreen mainScreen].bounds.size;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumLineSpacing = 0;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[FDMainCollectionViewCell class] forCellWithReuseIdentifier:FDMainCollectionViewCellIdentifier];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // nav layer
    
    CAGradientLayer *navLayer = [CAGradientLayer layer];
    navLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84);
    navLayer.colors = @[(__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    navLayer.locations = @[@0, @0.8, @1];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    navView.backgroundColor = [UIColor backgroundColor];
    navView.layer.mask = navLayer;
    
    [self.view addSubview:navView];
    
    /*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.tintColor = [UIColor whiteColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [navView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(15);
        make.top.equalTo(navView).offset(32);
    }];
     */
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareButton.tintColor = [UIColor whiteColor];
    [shareButton setImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
    
    [navView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView).offset(-15);
        make.top.equalTo(navView).offset(32);
    }];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    refreshButton.tintColor = [UIColor whiteColor];
    [refreshButton setImage:[UIImage imageNamed:@"rjb-add-refresh-icon"] forState:UIControlStateNormal];
    
    [navView addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-30);
        make.top.equalTo(navView).offset(32);
    }];
    
    _switchCityButton = [[FDSwitchCityButton alloc] init];
    _switchCityButton.cityLabel.text = @"正在定位...";
    [navView addSubview:_switchCityButton];
    [_switchCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView).offset(30);
        make.centerX.equalTo(navView);
    }];
    
    [_switchCityButton addTarget:self action:@selector(shouldSwitchCity:) forControlEvents:UIControlEventTouchUpInside];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _cities.count;
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView);
        make.top.equalTo(_switchCityButton.mas_bottom);
    }];
}

#pragma mark -
#pragma mark - collection view delegate datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FDMainCollectionViewCellIdentifier forIndexPath:indexPath];
    
    [cell feedCellWithData: _cities[indexPath.item]];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    [self reloadDataWithPage:page shouldReloadCollectionView:NO];
}

#pragma mark -

- (void)shouldSwitchCity:(id)sender {
    FDManageCityViewController *managerCityController = [self.storyboard instantiateViewControllerWithIdentifier:@"FDManageCityViewController"];
    [self.navigationController pushViewController:managerCityController animated:YES];
}

#pragma mark -

- (void)reloadDataWithPage:(NSInteger)page shouldReloadCollectionView:(BOOL)flag {
    _switchCityButton.cityLabel.text = _cities[page].cityName;
    _pageControl.numberOfPages = _cities.count;
    _pageControl.currentPage = page;
    
    if ([_cities[page].cityName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCATION]]) {
        _switchCityButton.positionImageView.alpha = 1;
    } else {
        _switchCityButton.positionImageView.alpha = 0;
    }
    
    if (flag) {
        [_collectionView reloadData];
    }
}

@end
