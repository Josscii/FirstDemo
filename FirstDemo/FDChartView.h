//
//  FDChartView.h
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FDChartViewTextPosition) {
    FDChartViewTextPositionTop=0,
    FDChartViewTextPositionBottom
};

@interface FDChartView : UIView

@property (nonatomic, assign) FDChartViewTextPosition position;

- (instancetype)initWithValues:(NSArray *)values titles:(NSArray *)titles startY:(CGFloat)y;

@property (nonatomic, copy) NSArray<NSNumber *> *values;
@property (nonatomic, copy) NSArray<NSString *> *titles;

@end
