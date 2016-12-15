//
//  FDSuggestionCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSuggestionCollectionViewCell.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"

@implementation FDSuggestionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureLayout];
        [self feedFakeData];
    }
    return self;
}

- (void)configureLayout {
    
    _typeIcon = [[UIImageView alloc] init];
    _typeIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_typeIcon];
    
    [_typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24.0f, 24.0f));
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerY.equalTo(self.contentView);
    }];
    
    _suggestionLabel = [UILabel commonLableWithFontName:PFSCR FontSize:15 colorAlpha:1];
    [self.contentView addSubview:_suggestionLabel];
    
    [_suggestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0f);
        make.top.equalTo(self.contentView).offset(18.0f);
    }];
    
    _typeLabel = [UILabel commonLableWithFontName:PFSCR FontSize:13 colorAlpha:0.6];
    [self.contentView addSubview:_typeLabel];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_suggestionLabel.mas_right);
        make.top.equalTo(_suggestionLabel.mas_bottom).offset(-1.0f);
    }];
}

- (void)feedFakeData {
    _typeIcon.image = [UIImage imageNamed:@"tq-view-cyzs-icon"];
    _suggestionLabel.text = @"薄短袖类";
    _typeLabel.text = @"穿衣";
}

@end
