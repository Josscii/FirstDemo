//
//  FDChartView.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDChartView.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"

#define LENGTH 60
#define INSETS 35
#define SCALE 2
#define HEIGHT 140
#define OFFSET 40

@interface FDChartView ()

@property (nonatomic, assign) CGFloat y;

@end

@implementation FDChartView

- (instancetype)initWithValues:(NSArray *)values titles:(NSArray *)titles startY:(CGFloat)y {
    self = [super init];
    if (self) {
        _values = values;
        _titles = titles;
        _y = y;
        _position = FDChartViewTextPositionTop;
        self.backgroundColor = [UIColor clearColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((values.count - 1) * LENGTH + INSETS * 2);
            make.height.mas_equalTo(HEIGHT);
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat scale = 0;
    
    if (_values.count == 0) {
        return;
    }
    
    // 找到温度最高和最低的那个
    NSInteger max = 0;
    NSInteger min = 0;
    for (NSInteger i = 0; i < _values.count; i++) {
        if (_values[i].integerValue > _values[max].integerValue) {
            max = i;
        }
        
        if (_values[i].integerValue < _values[min].integerValue) {
            min = i;
        }
    }
    
    // 计算出对应的 scale
    NSInteger desition = _values[max].integerValue - _values[min].integerValue;
    
    if (desition >= 12) {
        scale = 2;
    } else if (desition <= 5) {
        scale = 5;
    } else {
        scale = 3;
    }
    
    for (NSUInteger i = 0; i < _values.count; i++) {
        // 计算 start point
        CGFloat startY = _position == FDChartViewTextPositionTop ? 40 + scale * (_values[max].floatValue - _values[i].floatValue) : 100 - scale * (_values[i].floatValue - _values[min].floatValue);
        
        CGPoint pstart = CGPointMake(i * LENGTH + INSETS, startY);
        
        UIBezierPath *dot = [UIBezierPath bezierPathWithArcCenter:pstart radius:3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        dot.usesEvenOddFillRule = YES;
        
        if (i == 0) {
            [[[UIColor whiteColor] colorWithAlphaComponent:0.4] setFill];
        } else {
            [[UIColor whiteColor] setFill];
        }
        
        [dot fill];
        
        if (i == 0) {
            CGContextAddRect(UIGraphicsGetCurrentContext(), CGContextGetClipBoundingBox(UIGraphicsGetCurrentContext()));
            
            [dot addClip];
        }
        
        if (i < _values.count - 1) {
            CGFloat endY = _position == FDChartViewTextPositionTop ? 40 + scale * (_values[max].floatValue - _values[i+1].floatValue) : 100 - scale * (_values[i+1].floatValue - _values[min].floatValue);
            
            CGPoint pend = CGPointMake((i+1) * LENGTH + INSETS, endY);

            UIBezierPath *linePath = [UIBezierPath bezierPath];
            linePath.lineWidth = 2;
            
            [linePath moveToPoint:pstart];
            [linePath addLineToPoint:pend];

            if (i == 0) {
                [[[UIColor whiteColor] colorWithAlphaComponent:0.4] setStroke];
            } else {
                [[UIColor whiteColor] setStroke];
            }
            
            [linePath stroke];
            
        }
        
        CGFloat y = _position == FDChartViewTextPositionTop ? pstart.y - 25 : pstart.y + 10;
        
        CGPoint tp = CGPointMake(pstart.x - 10, y);
        
        UIFont *font = [UIFont fontWithName:SFDR size:13.0f];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:_titles[i] attributes:@{
                                                                                                      NSFontAttributeName: font,
                                                                                                      NSForegroundColorAttributeName: i == 0 ? [[UIColor whiteColor] colorWithAlphaComponent:0.4] : [UIColor whiteColor]
                                                                                                      }];
        
        [text drawAtPoint:tp];
    }
}

@end
