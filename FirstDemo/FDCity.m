//
//  FDCity.m
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDCity.h"

@implementation FDCity

- (instancetype)initWithCityName:(NSString *)cityName cityCode:(NSString *)cityCode {
    self = [super init];
    if (self) {
        _cityName = cityName;
        _cityCode = cityCode;
        _currentLocation = NO;
        _defaultCity = NO;
        _updating = NO;
    }
    return self;
}

- (void)configureWihtDictionary:(NSDictionary *)dic {
    // fcd
    NSArray *dics1 = dic[@"fcd"];
    NSMutableArray<FDForecastItemDate *> *fcd = [NSMutableArray array];
    for (NSDictionary *dic in dics1) {
        FDForecastItemDate *item = [[FDForecastItemDate alloc] initWihtDictionary:dic];
        [fcd addObject:item];
    }
    _fcd = fcd;
    
    // fch
    NSArray *dics2 = dic[@"fch"];
    NSMutableArray<FDForecastItemHour *> *fch = [NSMutableArray array];
    for (NSDictionary *dic in dics2) {
        FDForecastItemHour *item = [[FDForecastItemHour alloc] initWihtDictionary:dic];
        [fch addObject:item];
    }
    _fch = fch;
    
    // aqi
    FDAqi *aqi = [[FDAqi alloc] initWihtDictionary:dic[@"aqi"]];
    _aqi = aqi;
    
    // sun
    _sunRiseTime = dic[@"sun"][@"sr"];
    _sunFallTime = dic[@"sun"][@"ss"];
    
    // current
    FDForecastItemDate *curr = [[FDForecastItemDate alloc] initWihtDictionary:dic[@"curr"]];
    _curr = curr;
    
    // save time
    _saveTime = [NSDate date];
    
    // finished updating
    _updating = NO;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _cityName =  [aDecoder decodeObjectForKey:@"cityName"];
        _cityCode = [aDecoder decodeObjectForKey:@"cityCode"];
        _fcd = [aDecoder decodeObjectForKey:@"fcd"];
        _fch = [aDecoder decodeObjectForKey:@"fch"];
        _aqi = [aDecoder decodeObjectForKey:@"aqi"];
        _sunRiseTime = [aDecoder decodeObjectForKey:@"sr"];
        _sunFallTime = [aDecoder decodeObjectForKey:@"ss"];
        _curr = [aDecoder decodeObjectForKey:@"curr"];
        _saveTime = [aDecoder decodeObjectForKey:@"saveTime"];
        _defaultCity = [aDecoder decodeBoolForKey:@"defaultCity"];
        _currentLocation = [aDecoder decodeBoolForKey:@"currentLocation"];
        _updating = [aDecoder decodeBoolForKey:@"updating"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cityName forKey:@"cityName"];
    [aCoder encodeObject:_cityCode forKey:@"cityCode"];
    [aCoder encodeObject:_fcd forKey:@"fcd"];
    [aCoder encodeObject:_fch forKey:@"fch"];
    [aCoder encodeObject:_aqi forKey:@"aqi"];
    [aCoder encodeObject:_sunRiseTime forKey:@"sr"];
    [aCoder encodeObject:_sunFallTime forKey:@"ss"];
    [aCoder encodeObject:_curr forKey:@"curr"];
    [aCoder encodeObject:_saveTime forKey:@"saveTime"];
    [aCoder encodeBool:_defaultCity forKey:@"defaultCity"];
    [aCoder encodeBool:_currentLocation forKey:@"currentLocation"];
    [aCoder encodeBool:_updating forKey:@"updating"];
}

- (BOOL)isExpired {
    return [[NSDate date] timeIntervalSinceDate:_saveTime] > 60 * 60 * 10;
}

@end
