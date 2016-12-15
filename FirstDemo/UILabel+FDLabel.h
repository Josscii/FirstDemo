//
//  UILabel+FDLabel.h
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FDLabel)

+ (UILabel *)lowShadowLabelWithFontName:(NSString *)name FontSize:(CGFloat)size;
+ (UILabel *)commonLableWithFontName:(NSString *)name FontSize:(CGFloat)size colorAlpha:(CGFloat)alpha;;

@end
