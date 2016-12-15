//
//  UIColor+FDColor.h
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FDColor)

+ (UIColor *)backgroundColor;
+ (UIColor *)separatorLineColor;
+ (UIColor *)shadowColor;

+ (UIColor *)colorFromHexString:(NSString *)hexString;


@end