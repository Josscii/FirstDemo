//
//  TodayViewController.m
//  widget
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetTableViewCell1.h"
#import "WidgetTableViewCell2.h"
#import "WidgetTableViewCell3.h"
#import "WidgetTableViewCell4.h"
#import "FDUtils.h"
#import "FDConstants.h"
#import "FDCity.h"

#import "Masonry.h"

static NSString * const WidgetTableViewCell1Identifier = @"WidgetTableViewCell1Identifier";
static NSString * const WidgetTableViewCell2Identifier = @"WidgetTableViewCell2Identifier";
static NSString * const WidgetTableViewCell3Identifier = @"WidgetTableViewCell3Identifier";
static NSString * const WidgetTableViewCell4Identifier = @"WidgetTableViewCell4Identifier";

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FDCity *city;
@property (nonatomic, strong) NSString *notifi;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_city) {
        NSString *cityName = [[FDUtils sharedUtil].sharedDefaults objectForKey:@"defaultCity"];
        NSString *cityCode = [FDUtils codeOfCity:cityName];
        _city = [[FDCity alloc] initWithCityName:cityName cityCode:cityCode];
    }
    
    if (YES) {
        [FDUtils fetchDataWithCityCode:_city.cityCode completionBlock:^(NSDictionary *weatherData) {
            [_city configureWihtDictionary:weatherData];
            _notifi = weatherData[@"fcm"][@"description"];
            
            [_tableView reloadData];
        }];
    }
}

- (void)setupView {
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[WidgetTableViewCell1 class] forCellReuseIdentifier:WidgetTableViewCell1Identifier];
    [_tableView registerClass:[WidgetTableViewCell2 class] forCellReuseIdentifier:WidgetTableViewCell2Identifier];
    [_tableView registerClass:[WidgetTableViewCell3 class] forCellReuseIdentifier:WidgetTableViewCell3Identifier];
    [_tableView registerClass:[WidgetTableViewCell4 class] forCellReuseIdentifier:WidgetTableViewCell4Identifier];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

#pragma mark - 
#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_notifi) {
        if (indexPath.row == 0) {
            return 33;
        } else if (indexPath.row == 1) {
            return 45;
        } else if (indexPath.row == 2) {
            return 32;
        } else {
            return 93.5;
        }
    } else {
        if (indexPath.row == 0) {
            return 43;
        } else if (indexPath.row == 1) {
            return 66.5;
        } else if (indexPath.row == 2) {
            return 94;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_city) {
        return 0;
    }
    return _notifi ? 4 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WidgetTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:WidgetTableViewCell1Identifier forIndexPath:indexPath];
        cell.cityLabel.text = _city.cityName;
        return cell;
    } else if (indexPath.row == 1) {
        WidgetTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:WidgetTableViewCell2Identifier forIndexPath:indexPath];
        cell.tempLabel.text = [NSString stringWithFormat:@"%@°", _city.curr.currentTemp];
        cell.weatherTypeLabel.text = [NSString stringWithFormat:@"%@ %@/%@°", [FDUtils weatherType:_city.curr.weatherType.integerValue], _city.curr.tempLow, _city.curr.tempHigh];
        cell.aqiLabel.text = [NSString stringWithFormat:@"%@ %@", _city.aqi.grade, _city.aqi.pm25];
        return cell;
    } else if (indexPath.row == 2 && _notifi) {
        WidgetTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:WidgetTableViewCell3Identifier forIndexPath:indexPath];
        cell.notifiLabel.text = _notifi;
        return cell;
    } else {
        WidgetTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:WidgetTableViewCell4Identifier forIndexPath:indexPath];
        cell.city = _city;
        return cell;
    }
}

#pragma mark -

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    } else {
        self.preferredContentSize = CGSizeMake(0, 203);
    }
}

@end
