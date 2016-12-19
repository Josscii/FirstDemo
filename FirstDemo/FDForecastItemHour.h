//
//  FDForecastItemHour.h
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDForecastItemHour : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *hour;
@property (nonatomic, strong) NSNumber *temp;
@property (nonatomic, strong) NSNumber *weatherType;

- (instancetype)initWihtDictionary:(NSDictionary *)dic;

@end
