//
//  FDWeatherModel.h
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDWeatherModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;

- (instancetype)initWithCityCode:(NSString *)cityCode cityName:(NSString *)cityName;

@end
