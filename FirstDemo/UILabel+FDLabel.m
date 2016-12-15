//
//  UILabel+FDLabel.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "UILabel+FDLabel.h"
#import "UIColor+FDColor.h"

@implementation UILabel (FDLabel)

+ (UILabel *)lowShadowLabelWithFontName:(NSString *)name
                               FontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    label.shadowOffset = CGSizeMake(1.0f, 0.5f);
    label.shadowColor = [UIColor shadowColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:name size:size];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)commonLableWithFontName:(NSString *)name FontSize:(CGFloat)size colorAlpha:(CGFloat)alpha {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    label.font = [UIFont fontWithName:name size:size];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
