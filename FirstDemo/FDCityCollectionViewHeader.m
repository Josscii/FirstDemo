//
//  FDCityCollectionViewHeader.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDCityCollectionViewHeader.h"
#import "UILabel+FDLabel.h"
#import "UIColor+FDColor.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"

@implementation FDCityCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel commonLableWithFontName:PFSCR FontSize:12 colorAlpha:1];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

@end
