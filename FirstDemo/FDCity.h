//
//  FDCity.h
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDForecastItemHour.h"
#import "FDForecastItemDate.h"
#import "FDAqi.h"

@interface FDCity : NSObject <NSCoding>

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSArray<FDForecastItemDate *> *fcd;
@property (nonatomic, copy) NSArray<FDForecastItemHour *> *fch;
@property (nonatomic, strong) FDAqi *aqi;
@property (nonatomic, copy) NSString *sunRiseTime;
@property (nonatomic, copy) NSString *sunFallTime;
@property (nonatomic, strong) FDForecastItemDate *curr;
@property (nonatomic, strong) NSDate *saveTime; // 数据保存时间

@property (nonatomic, getter=isExpired, assign) BOOL expired;
@property (nonatomic, getter=isDefaultCity, assign) BOOL defaultCity;
@property (nonatomic, getter=isCurrentLocation, assign) BOOL currentLocation;

@property (nonatomic, getter=isUpdating, assign) BOOL updating;

- (instancetype)initWithCityName:(NSString *)cityName cityCode:(NSString *)cityCod;
- (void)configureWihtDictionary:(NSDictionary *)dic;

@end
