//
//  FDMainCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDMainCollectionViewCell.h"

#import "FDCurrentWeatherTableViewCell.h"
#import "FDTodayWeatherTableViewCell.h"
#import "FDForecastWeatherTableViewCell.h"
#import "FDSuggestionTableViewCell.h"
#import "FDSunriseTableViewCell.h"
#import "FDCity.h"
#import "FDHudView.h"

#import "UIColor+FDColor.h"
#import "FDConstants.h"
#import "FDUtils.h"

#import "Masonry/Masonry.h"

static NSString * const FDCurrentWeatherTableViewCellIdentifier = @"FDCurrentWeatherTableViewCell";
static NSString * const FDTodayWeatherTableViewCelldentifier = @"FDTodayWeatherTableViewCell";
static NSString * const FDForecastWeatherTableViewCellCelldentifier = @"FDForecastWeatherTableViewCell";
static NSString * const FDSuggestionTableViewCellCelldentifier = @"FDSuggestionTableViewCell";
static NSString * const FDSunriseTableViewCellCelldentifier = @"FDSunriseTableViewCell";

@interface FDMainCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FDCity *city;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, assign) BOOL hasAnimated;
@property (nonatomic, strong) FDHudView *hud;

@end

@implementation FDMainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hasAnimated = NO;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _mainTableView = [[UITableView alloc] init];
    [_mainTableView registerClass:[FDCurrentWeatherTableViewCell class] forCellReuseIdentifier:FDCurrentWeatherTableViewCellIdentifier];
    [_mainTableView registerClass:[FDTodayWeatherTableViewCell class] forCellReuseIdentifier:FDTodayWeatherTableViewCelldentifier];
    [_mainTableView registerClass:[FDForecastWeatherTableViewCell class] forCellReuseIdentifier:FDForecastWeatherTableViewCellCelldentifier];
    [_mainTableView registerClass:[FDSuggestionTableViewCell class] forCellReuseIdentifier:FDSuggestionTableViewCellCelldentifier];
    [_mainTableView registerClass:[FDSunriseTableViewCell class] forCellReuseIdentifier:FDSunriseTableViewCellCelldentifier];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.allowsSelection = NO;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.showsVerticalScrollIndicator = NO;
    UIEdgeInsets insets = _mainTableView.contentInset;
    insets.top = 64;
    _mainTableView.contentInset = insets;
    _mainTableView.contentOffset = CGPointMake(0, -64);
    [self.contentView addSubview:_mainTableView];
    
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _hud = [[FDHudView alloc] initWithFrame:self.contentView.bounds];
    _hud.alpha = 0;
    [self.contentView addSubview:_hud];
}

- (void)prepareForReuse {
    _hasAnimated = NO;
    _city = nil;
    _hud.alpha = 0;
    _mainTableView.alpha = 1;
}

#pragma mark -
#pragma mark - tableview delegate and datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 230;
    } else if (indexPath.row == 1) {
        return 102;
    } else if (indexPath.row == 2) {
        return 260;
    } else if (indexPath.row == 3) {
        return 147;
    } else {
        return 189;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.city) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FDCurrentWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FDCurrentWeatherTableViewCellIdentifier forIndexPath:indexPath];
        [cell feedCellWithData:self.city];
        return cell;
    } else if (indexPath.row == 1) {
        FDTodayWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FDTodayWeatherTableViewCelldentifier forIndexPath:indexPath];
        [cell feedCellWithData:self.city];
        return cell;
    } else if (indexPath.row == 2){
        FDForecastWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FDForecastWeatherTableViewCellCelldentifier forIndexPath:indexPath];
        [cell feedCellWithData:self.city];
        return cell;
    } else if (indexPath.row == 3) {
        FDSuggestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FDSuggestionTableViewCellCelldentifier forIndexPath:indexPath];
        return cell;
    } else {
        FDSunriseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FDSunriseTableViewCellCelldentifier forIndexPath:indexPath];
        [cell feedCellWithData:self.city];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4 && !_hasAnimated) {
        FDSunriseTableViewCell *cell1 = (FDSunriseTableViewCell *)cell;
        [cell1 animateSunRise];
        _hasAnimated = YES;
    }
}

- (void)feedCellWithData:(id)data {
    _city = data;
    [_mainTableView reloadData];
}

- (void)refreshCellWithData:(id)data {
    _city = data;
    _hasAnimated = NO;
    [_mainTableView reloadData];
}

- (void)startLoading {
    _hud.alpha = 1;
    _mainTableView.alpha = 0;
}

- (void)endLoading {
    _hud.alpha = 0;
    _mainTableView.alpha = 1;
}

@end
