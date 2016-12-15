//
//  UIImageView+FDImageView.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "UIImageView+FDImageView.h"
#import "UIColor+FDColor.h"

@implementation UIImageView (FDImageView)

+ (UIImageView *)shadowImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.shadowColor = [UIColor shadowColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(1, 0.5);
    imageView.layer.shadowOpacity = 1;
    imageView.layer.shadowRadius = 1.0;
    imageView.clipsToBounds = NO;
    return imageView;
}

@end
