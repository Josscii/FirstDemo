
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
#import "UIView+OldSchoolSnapshots.h"
#import "FDShareViewController.h"

#import "Masonry/Masonry.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UShareUI/UMSocialUIManager.h"

static NSString * const FDMainCollectionViewCellIdentifier = @"FDMainCollectionViewCellIdentifier";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) FDSwitchCityButton *switchCityButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) CAGradientLayer *navLayer;
@property (nonatomic, strong) UIButton *dimmingView;
@property (nonatomic, strong) FDShareViewController *shareViewController;

@property (nonatomic, strong) NSMutableArray<FDCity *> *cities;
@property (nonatomic, strong) NSMutableArray *fetchDataTasks;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView];
    
    _firstLoad = YES;
    _cities = [[FDUtils getAllSeletedCities] mutableCopy];
    _fetchDataTasks = [NSMutableArray array];
    
    if (!_cities) {
        _cities = [NSMutableArray array];
    } else {
        [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
    }
    
    NSDate *lastLocationTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLocationTime"];
    
    if (!lastLocationTime || [[NSDate date] timeIntervalSinceDate:lastLocationTime] > 1) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error) {
                if (_cities.count == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请检查网络或是否为本APP开启权限, 已为您自动设为北京市" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    FDCity *defaultCity = [[FDCity alloc] initWithCityName:@"北京" cityCode:[FDUtils codeOfCity: @"北京"]];
                    defaultCity.defaultCity = YES;
                    [_cities addObject:defaultCity];
                    [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastLocationTime"];
                NSString *cityName = [regeocode.district substringToIndex:2];
                NSString *cityCode = [FDUtils codeOfCity:cityName];
                [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:LOCATION];
                
                if (_cities.count == 0) {
                    FDCity *current = [[FDCity alloc] initWithCityName:cityName cityCode:cityCode];
                    [[FDUtils sharedUtil].sharedDefaults setObject:current.cityName forKey:@"defaultCity"];
                    current.currentLocation = YES;
                    current.defaultCity = YES;
                    [_cities addObject:current];
                    [self reloadDataWithPage:0 shouldReloadCollectionView:YES];
                }
            }
        }];
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
    for (NSURLSessionDataTask *task in _fetchDataTasks) {
        _refreshButton.userInteractionEnabled = YES;
        [task cancel];
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
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = _cities.count;
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_navView);
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
    
    FDCity *city = _cities[indexPath.item];
    
    if (city.isUpdating) {
        [self startLoadingWithCell:cell];
        return cell;
    }
    
    if (!city.saveTime) {
        city.updating = YES;
        [self startLoadingWithCell:cell];
        NSURLSessionDataTask *task = [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [city configureWihtDictionary:weatherData];
                city.updating = NO;
                [self setBackgroundColorWithCity:city refresh:YES];
                [self endLoadingWithCell:cell];
                [cell feedCellWithData:city];
            });
        }];
        [_fetchDataTasks addObject:task];
    } else {
        if (city.isExpired) {
            city.updating = YES;
            [self startLoadingWithCell:cell];
            NSURLSessionDataTask *task = [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [city configureWihtDictionary:weatherData];
                    city.updating = NO;
                    [self setBackgroundColorWithCity:city refresh:YES];
                    [self endLoadingWithCell:cell];
                    [cell feedCellWithData:city];
                });
            }];
            [_fetchDataTasks addObject:task];
        } else {
            [cell feedCellWithData:city];
            [self setBackgroundColorWithCity:city refresh:YES];
        }
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    [self setBackgroundColorWithCity:_cities[page] refresh:NO];
    [self reloadDataWithPage:page shouldReloadCollectionView:NO];
}

#pragma mark -
#pragma mark - button actions

- (void)shouldSwitchCity:(id)sender {
    FDManageCityViewController *managerCityController = [self.storyboard instantiateViewControllerWithIdentifier:@"FDManageCityViewController"];
    [self.navigationController pushViewController:managerCityController animated:YES];
}

- (void)share:(id)sender {
    
    NSInteger page = _collectionView.contentOffset.x / SCREEN_WIDTH;
    
    FDCity *city = _cities[page];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateString = [dateFormatter stringFromDate:city.saveTime];
    NSString *desc = [NSString stringWithFormat:@"%@%@,%@℃,%@,%@%@级,湿度%@,空气指数%@,%@。更多天气信息,请点击 http://www.51wnl.com/products.html?f=15&cityid=%@&p=i", dateString, city.cityName, city.curr.currentTemp, city.curr.weatherType, city.curr.windDirection, city.curr.windSpeed, city.curr.sendibleTemp, city.aqi.pm25, city.aqi.grade, city.cityCode];
    UIImage *image = [self.view ar_snapshot];
    
    if (!_shareViewController) {
        _shareViewController = [[FDShareViewController alloc] init];
        _shareViewController.modalPresentationStyle = UIModalPresentationCustom;
        _shareViewController.transitioningDelegate = self;
    }
    _shareViewController.image = image;
    _shareViewController.desc = desc;
    _shareViewController.city = city;
    
    [self presentViewController:_shareViewController animated:YES completion:nil];
}

- (void)refresh:(id)sender {
    NSInteger page = _collectionView.contentOffset.x / SCREEN_WIDTH;
    
    FDCity *city = _cities[page];
    FDMainCollectionViewCell *cell = (FDMainCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
    
    city.updating = YES;
    [self startLoadingWithCell:cell];
    
    if ([[NSDate date] timeIntervalSinceDate:city.saveTime] < 5 * 60 * 60) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            city.updating = NO;
            [self endLoadingWithCell:cell];
            [cell refreshCellWithData:city];
        });
    } else {
        [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
            [city configureWihtDictionary:weatherData];
            city.updating = NO;
            [self setBackgroundColorWithCity:city refresh:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endLoadingWithCell:cell];
                [cell refreshCellWithData:city];
            });
        }];
    }
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

- (void)startLoadingWithCell:(FDMainCollectionViewCell *)cell {
    
    if (!_refreshButton.layer.animationKeys) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = 0;
        animation.toValue = [NSNumber numberWithDouble:-M_PI * 2];
        animation.duration = 1;
        animation.repeatCount = CGFLOAT_MAX;
        [_refreshButton.layer addAnimation:animation forKey:@"rotationAnimation"];
        _refreshButton.userInteractionEnabled = NO;
    }
    
    [cell startLoading];
}

- (void)endLoadingWithCell:(FDMainCollectionViewCell *)cell {
    _refreshButton.userInteractionEnabled = YES;
    [_refreshButton.layer removeAllAnimations];
    [cell endLoading];
}

- (void)setBackgroundColorWithCity:(FDCity *)city refresh:(BOOL)refresh {
    
    NSInteger page = _collectionView.contentOffset.x / SCREEN_WIDTH;
    
    if (refresh && ![_cities[page] isEqual:city]) {
        return;
    }
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *currentYMD = [dateFormatter stringFromDate:now];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", currentYMD, city.sunFallTime]];
    
    [UIView animateWithDuration:0.1 animations:^{
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

#pragma mark -
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (!_dimmingView) {
        _dimmingView = [[UIButton alloc] initWithFrame:self.view.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
    }
    
    if (toViewController.isBeingPresented) {
        _dimmingView.alpha = 0;
        [[transitionContext containerView] addSubview:_dimmingView];
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
            _dimmingView.alpha = 0.5;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
            _dimmingView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    }
}

@end
