//
//  FDUtils.h
//  FirstDemo
//
//  Created by mxl on 16/12/3.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDConstants.h"
#import "FDCity.h"

@interface FDUtils : NSObject

+ (NSString *)weatherType:(WeatherType)type;
+ (NSString *)windDirection:(WindDirection)type;
+ (NSString *)tempWithNumber:(NSNumber *)number;

+ (NSString *)weakdayWithDate:(NSString *)dateString;
+ (NSString *)dateWithString:(NSString *)dateString;

+ (NSNumber *)hourOfTime:(NSString *)s;

+ (NSArray<FDCity *> *)getAllSeletedCities;
+ (void)saveAllSeletedCities:(NSArray<FDCity *> *)cities;

+ (NSURLSessionDataTask *)fetchDataWithCityCode:(NSString *)cityCode completionBlock:(void (^)(NSDictionary *weatherData))block;

+ (NSString *)provinceOfCity:(FDCity *)city;
+ (NSString *)codeOfCity:(NSString *)cityName;

@end
