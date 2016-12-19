//
//  FDUtils.h
//  FirstDemo
//
//  Created by mxl on 16/12/3.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDConstants.h"
#import "FDWeatherModel.h"

@interface FDUtils : NSObject

+ (NSString *)weatherType:(WeatherType)type;
+ (NSString *)windDirection:(WindDirection)type;
+ (NSString *)tempWithNumber:(NSNumber *)number;

+ (NSString *)weakdayWithDate:(NSString *)dateString;
+ (NSString *)dateWithString:(NSString *)dateString;

+ (NSNumber *)hourOfTime:(NSString *)s;

+ (NSArray<FDWeatherModel *> *)getAllSeletedCities;
+ (void)saveAllSeletedCities:(NSArray<FDWeatherModel *> *)cities;

+ (void)fetchDataWithCityCode:(NSString *)cityCode completionBlock:(void (^)(NSDictionary *weatherData))block;

+ (NSString *)provinceOfCity:(FDWeatherModel *)city;
+ (NSArray<FDWeatherModel *> *)findCitiesWithText:(NSString *)text;
+ (NSString *)codeOfCity:(NSString *)cityName;

+ (void)toPinyin;

@end
