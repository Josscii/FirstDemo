//
//  FDAqi.m
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDAqi.h"

@implementation FDAqi

- (instancetype)initWihtDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _pm25 = dic[@"pm25"];
        _grade = dic[@"grade"];
        _index = dic[@"index"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _pm25 =  [aDecoder decodeObjectForKey:@"pm25"];
        _grade = [aDecoder decodeObjectForKey:@"grade"];
        _index = [aDecoder decodeObjectForKey:@"index"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_pm25 forKey:@"pm25"];
    [aCoder encodeObject:_grade forKey:@"grade"];
    [aCoder encodeObject:_index forKey:@"index"];
}

@end
