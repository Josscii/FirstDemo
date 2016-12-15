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

@end
