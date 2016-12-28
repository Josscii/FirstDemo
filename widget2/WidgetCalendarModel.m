//
//  WidgetCalendarModel.m
//  FirstDemo
//
//  Created by mxl on 16/12/28.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetCalendarModel.h"

@implementation WidgetCalendarModel

- (instancetype)initWithSolarDay:(NSString *)solarDay lunarDay:(NSString *)lunarDay festival:(NSString *)festival vocation:(NSNumber *)vocation jieqi:(NSString *)jieqi isLastOrNext:(BOOL)lastOrNext {
    self = [super init];
    if (self) {
        _solarDay = solarDay;
        _lunarDay = lunarDay;
        _festival = festival;
        _vocation = vocation;
        _jieqi = jieqi;
        _lastOrNext = lastOrNext;
        _today = NO;
    }
    return self;
}

@end
