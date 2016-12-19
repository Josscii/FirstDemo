//
//  FDAqi.h
//  FirstDemo
//
//  Created by mxl on 16/12/19.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDAqi : NSObject <NSCoding>

@property (nonatomic, copy) NSString *pm25;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *index;

- (instancetype)initWihtDictionary:(NSDictionary *)dic;

@end
