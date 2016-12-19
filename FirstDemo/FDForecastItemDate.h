//
//  FDForecastItemDate.h
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDForecastItemDate : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *weatherType;
@property (nonatomic, strong) NSNumber *relativeHumidity;
@property (nonatomic, copy) NSString *windDirection;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSNumber *sendibleTemp;
@property (nonatomic, strong) NSNumber *currentTemp;

- (instancetype)initWihtDictionary:(NSDictionary *)dic;

@end
