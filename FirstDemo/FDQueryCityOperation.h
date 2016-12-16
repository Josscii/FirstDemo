//
//  FDQueryCityOperation.h
//  FirstDemo
//
//  Created by mxl on 16/12/16.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDQueryCityOperation : NSOperation

- (instancetype)initWithKey:(NSString *)key complectionWithResultBlock:(void (^)(NSArray *results))block;

@end
