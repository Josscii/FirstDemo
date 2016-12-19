//
//  FDForecastItemHour.m
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDForecastItemHour.h"

@implementation FDForecastItemHour

- (instancetype)initWihtDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {        
        _hour = dic[@"h"];
        _temp = dic[@"tm"];
        _weatherType = dic[@"wt"];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _hour =  [aDecoder decodeObjectForKey:@"h"];
        _temp = [aDecoder decodeObjectForKey:@"tm"];
        _weatherType = [aDecoder decodeObjectForKey:@"wt"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_hour forKey:@"h"];
    [aCoder encodeObject:_temp forKey:@"tm"];
    [aCoder encodeObject:_weatherType forKey:@"wt"];
}

@end
