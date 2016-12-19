//
//  FDForecastItemDate.m
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDForecastItemDate.h"

@implementation FDForecastItemDate

- (instancetype)initWihtDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _date = dic[@"d"];
        _tempLow = dic[@"tl"];
        _tempHigh = dic[@"th"];
        _weatherType = dic[@"wt"];
        _relativeHumidity = dic[@"rh"];
        _windDirection = dic[@"wd"];
        _windSpeed = dic[@"ws"];
        _sendibleTemp = dic[@"st"];
        _currentTemp = dic[@"ct"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _date =  [aDecoder decodeObjectForKey:@"d"];
        _tempLow = [aDecoder decodeObjectForKey:@"tl"];
        _tempHigh = [aDecoder decodeObjectForKey:@"th"];
        _weatherType = [aDecoder decodeObjectForKey:@"wt"];
        _relativeHumidity = [aDecoder decodeObjectForKey:@"rh"];
        _windDirection = [aDecoder decodeObjectForKey:@"wd"];
        _windSpeed = [aDecoder decodeObjectForKey:@"ws"];
        _sendibleTemp = [aDecoder decodeObjectForKey:@"st"];
        _currentTemp = [aDecoder decodeObjectForKey:@"ct"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"d"];
    [aCoder encodeObject:_tempLow forKey:@"tl"];
    [aCoder encodeObject:_tempHigh forKey:@"th"];
    [aCoder encodeObject:_weatherType forKey:@"wt"];
    [aCoder encodeObject:_relativeHumidity forKey:@"rh"];
    [aCoder encodeObject:_windDirection forKey:@"wd"];
    [aCoder encodeObject:_windSpeed forKey:@"ws"];
    [aCoder encodeObject:_sendibleTemp forKey:@"st"];
    [aCoder encodeObject:_currentTemp forKey:@"ct"];
}

@end
