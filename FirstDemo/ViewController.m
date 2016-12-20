
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
#import "FDUtils.h"
#import "FDCity.h"
#import "FDHudView.h"

#import "Masonry/Masonry.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UShareUI/UMSocialUIManager.h"

static NSString * const FDMainCollectionViewCellIdentifier = @"FDMainCollectionViewCellIdentifier";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<FDCity *> *cities;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) FDSwitchCityButton *switchCityButton;
@property (nonatomic, strong) FDHudView *hud;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) CAGradientLayer *navLayer;

@property (nonatomic, assign) BOOL forceRefresh;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView];
    
    _firstLoad = YES;
    _forceRefresh = NO;
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
            
            FDCity *current = [[FDCity alloc] initWithCityName:cityName cityCode:cityCode];
            
            [_cities addObject:current];
            [FDUtils saveAllSeletedCities:[_cities copy]];
            
            [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:LOCATION];
            
            [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
            [_collectionView reloadData];
        }];
    } else {
        [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
        [self setBackgroundColorWithCity:_cities[0]];
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
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [FDUtils saveAllSeletedCities:[_cities copy]];
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
    _collectionView.prefetchingEnabled = NO;
    [_collectionView registerClass:[FDMainCollectionViewCell class] forCellWithReuseIdentifier:FDMainCollectionViewCellIdentifier];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // nav layer
    
    _navLayer = [CAGradientLayer layer];
    _navLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84);
    _navLayer.colors = @[(__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    _navLayer.locations = @[@0, @0.8, @1];
    
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    _navView.backgroundColor = [UIColor backgroundColor];
    _navView.layer.mask = _navLayer;
    
    [self.view addSubview:_navView];
    
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
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navView).offset(-15);
        make.top.equalTo(_navView).offset(32);
    }];
    
    _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _refreshButton.tintColor = [UIColor whiteColor];
    [_refreshButton setImage:[UIImage imageNamed:@"rjb-add-refresh-icon"] forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    [_navView addSubview:_refreshButton];
    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-30);
        make.top.equalTo(_navView).offset(32);
    }];
    
    _switchCityButton = [[FDSwitchCityButton alloc] init];
    _switchCityButton.cityLabel.text = @"正在定位...";
    [_navView addSubview:_switchCityButton];
    [_switchCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navView).offset(30);
        make.centerX.equalTo(_navView);
    }];
    
    [_switchCityButton addTarget:self action:@selector(shouldSwitchCity:) forControlEvents:UIControlEventTouchUpInside];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _cities.count;
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
        make.top.equalTo(_switchCityButton.mas_bottom);
    }];
    
    // hud
    _hud = [[FDHudView alloc] init];
    _hud.alpha = 0;
    [self.view addSubview:_hud];
    
    [_hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark - collection view delegate datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FDMainCollectionViewCellIdentifier forIndexPath:indexPath];
    
    FDCity *city = _cities[indexPath.item];
    
    if (!city.saveTime) {
        [self startLoading];
        [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
            [city configureWihtDictionary:weatherData];
            [self endLoading];
            [self setBackgroundColorWithCity:city];
            [cell feedCellWithData:city];
        }];
    } else {
        if (city.isExpired) {
            [self startLoading];
            [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
                [city configureWihtDictionary:weatherData];
                [self endLoading];
                [self setBackgroundColorWithCity:city];
                [cell feedCellWithData:city];
            }];
        } else {
            if (_forceRefresh) {
                _forceRefresh = NO;
                [self startLoading];
                [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
                    [city configureWihtDictionary:weatherData];
                    [self endLoading];
                    [self setBackgroundColorWithCity:city];
                    [cell feedCellWithData:city];
                }];
            } else {
                [cell feedCellWithData:city];
            }
        }
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    [self setBackgroundColorWithCity:_cities[page]];
    [self reloadDataWithPage:page shouldReloadCollectionView:NO];
}

#pragma mark -
#pragma mark - button actions

- (void)shouldSwitchCity:(id)sender {
    FDManageCityViewController *managerCityController = [self.storyboard instantiateViewControllerWithIdentifier:@"FDManageCityViewController"];
    [self.navigationController pushViewController:managerCityController animated:YES];
}

- (void)share:(id)sender {
    // __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
    }];
}

- (void)refresh:(id)sender {
    _forceRefresh = YES;
    
    NSInteger page = _collectionView.contentOffset.x / SCREEN_WIDTH;
    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:page inSection:0]]];
}

#pragma mark -
#pragma mark - refresh

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

- (void)startLoading {
    _hud.alpha = 1;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithDouble:M_PI * 2];
    animation.duration = 2;
    animation.repeatCount = CGFLOAT_MAX;
    [_refreshButton.layer
     addAnimation:animation forKey:nil];
}

- (void)endLoading {
    _hud.alpha = 0;
    [_refreshButton.layer removeAllAnimations];
}

- (void)setBackgroundColorWithCity:(FDCity *)city {
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *currentYMD = [dateFormatter stringFromDate:now];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", currentYMD, city.sunFallTime]];
    
    [UIView animateWithDuration:0.25 animations:^{
        if ([now compare:endDate] == NSOrderedDescending) {
            self.view.backgroundColor= [UIColor backgroundColorNight];
            _navView.backgroundColor = [UIColor backgroundColorNight];
            _navLayer.colors = @[(__bridge id)[UIColor backgroundColorNight].CGColor, (__bridge id)[UIColor backgroundColorNight].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        } else {
            if (city.curr.weatherType.integerValue == 0) {
                self.view.backgroundColor= [UIColor backgroundColor];
                _navView.backgroundColor = [UIColor backgroundColor];
                _navLayer.colors = @[(__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor backgroundColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
            } else {
                self.view.backgroundColor= [UIColor backgroundColorDayRain];
                _navView.backgroundColor = [UIColor backgroundColorDayRain];
                _navLayer.colors = @[(__bridge id)[UIColor backgroundColorDayRain].CGColor, (__bridge id)[UIColor backgroundColorDayRain].CGColor, (__bridge id)[UIColor clearColor].CGColor];
            }
        }
    }];
}

@end
