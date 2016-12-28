//
//  WidgetCalendarModel.h
//  FirstDemo
//
//  Created by mxl on 16/12/28.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetCalendarModel : NSObject

@property (nonatomic, strong) NSString *solarDay;
@property (nonatomic, strong) NSString *lunarDay;
@property (nonatomic, strong) NSString *festival;
@property (nonatomic, strong) NSNumber *vocation;
@property (nonatomic, strong) NSString *jieqi;
@property (nonatomic, getter=isLastOrNext, assign) BOOL lastOrNext;
@property (nonatomic, getter=isToday, assign) BOOL today;

- (instancetype)initWithSolarDay:(NSString *)solarDay lunarDay:(NSString *)lunarDay festival:(NSString *)festival vocation:(NSNumber *)vocation jieqi:(NSString *)jieqi isLastOrNext:(BOOL)lastOrNext;

@end
