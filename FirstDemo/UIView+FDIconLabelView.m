//
//  UIView+FDIconLabelView.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "UIView+FDIconLabelView.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"

@implementation UIView (FDIconLabelView)

+ (UIView *)iconLabelViewWithIconName:(NSString *)name titleInfo:(NSString *)title {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:name];
    [imageView sizeToFit];
    
    UILabel *label = [UILabel lowShadowLabelWithFontName:PFSCR FontSize:15.0f];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageView, label]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 5.0;
    
    return stackView;
}

@end
