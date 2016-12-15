//
//  FDWeatherModel.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDWeatherModel.h"

@implementation FDWeatherModel

- (instancetype)initWithCityCode:(NSString *)cityCode cityName:(NSString *)cityName {
    self = [super init];
    if (self) {
        _cityCode = cityCode;
        _cityName = cityName;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _cityCode = [aDecoder decodeObjectForKey:@"citycode"];
        _cityName = [aDecoder decodeObjectForKey:@"cityname"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cityCode forKey:@"citycode"];
    [aCoder encodeObject:_cityName forKey:@"cityname"];
}

@end
