//
//  FDSelectCityViewController.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSelectCityViewController.h"
#import "UIColor+FDColor.h"
#import "Masonry/Masonry.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"
#import "FDCityCollectionViewCell.h"
#import "FDCityCollectionViewHeader.h"
#import "FDWeatherModel.h"
#import "FDUtils.h"

static NSString * const FDCityCollectionViewCellIdentifier = @"FDCityCollectionViewCell";

@interface FDSelectCityViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UITableView *searchResultTableView;

@property (nonatomic, strong) NSMutableArray<FDWeatherModel *> *hotCities;
@property (nonatomic, strong) NSMutableArray<FDWeatherModel *> *cities;
@property (nonatomic, strong) NSArray<FDWeatherModel *> *searchCities;

@property (nonatomic, strong) NSOperationQueue *queryQueue;

@end

@implementation FDSelectCityViewController

#pragma mark -
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _queryQueue = [[NSOperationQueue alloc] init];
    _queryQueue.name = @"Query-For-Cities-Queue";
    
    [self setupView];
    [self fetchHotCity];
    // [self feedFakeData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [FDUtils saveAllSeletedCities:_cities];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor backgroundColor];
    
    _navView = [UIView new];
    [self.view addSubview:_navView];
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_offset(44);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeButton.tintColor = [UIColor whiteColor];
    [_closeButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navView);
        make.left.equalTo(_navView).offset(15);
    }];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.placeholder = @"搜索";
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(45);
        make.height.mas_equalTo(30);
        make.top.equalTo(_navView.mas_bottom).offset(15);
    }];
    
    UIView *currentPositionView = [UIView new];
    currentPositionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:currentPositionView];
    
    [currentPositionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"location"];
    
    [currentPositionView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 10));
        make.centerY.equalTo(currentPositionView);
        make.left.equalTo(currentPositionView).offset(15);
    }];
    
    _positionLabel = [UILabel commonLableWithFontName:PFSCR FontSize:16 colorAlpha:1];
    _positionLabel.textColor = [UIColor colorFromHexString:@"#333333"];
    
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION];
    _positionLabel.text = [NSString stringWithFormat:@"%@ %@", cityName, [FDUtils provinceOfCity:[[FDWeatherModel alloc] initWithCityCode:[FDUtils codeOfCity:cityName] cityName:cityName]]];
    
    [currentPositionView addSubview:_positionLabel];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(currentPositionView);
        make.left.equalTo(imageView.mas_right).offset(3);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCurrentLocation:)];
    [currentPositionView addGestureRecognizer:tap];
    
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = [UIColor colorFromHexString:@"#eaeaea"];
    [currentPositionView addSubview:separatorView];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentPositionView).offset(15);
        make.right.equalTo(currentPositionView).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(currentPositionView);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 * 15) / 4, 30);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.allowsMultipleSelection = YES;
    [_collectionView registerClass:[FDCityCollectionViewCell class] forCellWithReuseIdentifier:FDCityCollectionViewCellIdentifier];
    [_collectionView registerClass:[FDCityCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(currentPositionView.mas_bottom);
    }];
    
    _searchResultTableView = [[UITableView alloc] init];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    _searchResultTableView.showsVerticalScrollIndicator = NO;
    [_searchResultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResultCell"];
    _searchResultTableView.tableFooterView = [UIView new];
    _searchResultTableView.hidden = YES;
    [self.view addSubview:_searchResultTableView];
    
    [_searchResultTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_searchBar.mas_bottom).offset(20);
    }];
}

#pragma mark -
#pragma mark - result table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    FDWeatherModel *model = _searchCities[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@---%@", [FDUtils provinceOfCity:model], model.cityName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_cities addObject:_hotCities[indexPath.item]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - searchbar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_navView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-35);
    }];
    
    [_searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        _searchResultTableView.hidden = NO;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    _searchCities = @[];
    
    [_searchResultTableView reloadData];
    
    [_navView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
    }];
    
    [_searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(45);
    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];

    _searchResultTableView.hidden = YES;
    [searchBar resignFirstResponder];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_queryQueue cancelAllOperations];
    
    [_queryQueue addOperationWithBlock:^{
        NSArray *results = [[FDUtils findCitiesWithText:searchText] copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _searchCities = results;
            [_searchResultTableView reloadData];
        });
    }];
}

#pragma mark -
#pragma mark - collection view delegate and datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _hotCities.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    FDCityCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.titleLabel.text = @"国内热门城市";
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FDCityCollectionViewCellIdentifier forIndexPath:indexPath];
    
    FDWeatherModel *hotCity = _hotCities[indexPath.item];
    
    for (FDWeatherModel *city in _cities) {
        if ([city.cityName isEqualToString:hotCity.cityName]) {
            
            // must call both of this http://stackoverflow.com/questions/15330844/uicollectionview-select-and-deselect-issue
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    cell.cityLabel.text = hotCity.cityName;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_cities addObject:_hotCities[indexPath.item]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // reselected the cell but this won't call `didSelecteItemAtIndexPath`
    FDCityCollectionViewCell *cell = (FDCityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    // alert the user the cell has been selected
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此城市已添加" preferredStyle:UIAlertControllerStyleAlert];;
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark - fetch data

- (void)fetchHotCity {
    
    _searchCities = @[];
    
    _cities = [[FDUtils getAllSeletedCities] mutableCopy];
    
    _hotCities = [NSMutableArray array];
    
    NSData *hotCityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hotcity" ofType:@".json"]];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:hotCityData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *array = json[@"cnhot"];
    
    for (NSDictionary *city in array) {
        NSString *cityName = city[@"cityname"];
        NSString *cityCode = city[@"citycode"];
        FDWeatherModel *model = [[FDWeatherModel alloc] initWithCityCode:cityCode cityName:cityName];
        [_hotCities addObject:model];
    }
    
    [_collectionView reloadData];
}

- (void)feedFakeData {
    _positionLabel.text = @"定位中...";
}

#pragma mark -
#pragma mark - others

- (void)alertUser:(NSNotification *)notification {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此城市已添加" preferredStyle:UIAlertControllerStyleAlert];;
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:alertAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectCurrentLocation:(id)sender {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION];
    for (FDWeatherModel *city in _cities) {
        if ([city.cityName isEqualToString:cityName]) {
            return;
        }
    }
    
    FDWeatherModel *city = [[FDWeatherModel alloc] initWithCityCode:[FDUtils codeOfCity:cityName] cityName:cityName];
    [_cities addObject:city];
    [FDUtils saveAllSeletedCities:_cities];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
