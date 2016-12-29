//
//  UIColor+FDColor.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "UIColor+FDColor.h"

@implementation UIColor (FDColor)

+ (UIColor *)backgroundColor {
    return [self colorFromHexString:@"#2ea9df"];
}

+ (UIColor *)backgroundColorNight {
    return [self colorFromHexString:@"#122e3b"];
}

+ (UIColor *)backgroundColorDayRain {
    return [self colorFromHexString:@"#4e849c"];
}

+ (UIColor *)separatorLineColor {
    return [[self whiteColor] colorWithAlphaComponent:0.2f];;
}

+ (UIColor *)shadowColor {
    return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)wd_redColor {
    return [UIColor colorWithRed:235.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
}

+ (UIColor *)wd_blackColor {
    return [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
}

+ (UIColor *)wd_blueColor {
    return [UIColor colorWithRed:15.0/255.0 green:184.0/255.0 blue:255.0/255.0 alpha:1.0];
}

@end
