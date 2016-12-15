//
//  FDCityCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDCityCollectionViewCell.h"
#import "UIColor+FDColor.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"

@interface FDCityCollectionViewCell ()

@end

@implementation FDCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorFromHexString:@"#d1d1d1"].CGColor;
    
    _cityLabel = [UILabel commonLableWithFontName:PFSCR FontSize:15 colorAlpha:1];
    _cityLabel.textColor = [UIColor colorFromHexString:@"#d1d1d1"];
    
    [self.contentView addSubview:_cityLabel];
    
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = [UIColor colorFromHexString:@"#36c3ff"].CGColor;
        self.cityLabel.textColor = [UIColor colorFromHexString:@"#2ea9df"];
    } else {
        self.layer.borderColor = [UIColor colorFromHexString:@"#d1d1d1"].CGColor;
        self.cityLabel.textColor = [UIColor colorFromHexString:@"#d1d1d1"];
    }
}

@end
