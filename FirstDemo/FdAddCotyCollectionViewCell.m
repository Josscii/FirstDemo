//
//  FdAddCotyCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FdAddCotyCollectionViewCell.h"
#import "Masonry/Masonry.h"
#import "FDConstants.h"

@implementation FdAddCotyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    // container
    UIView *container = [[UIView alloc] init];
    
    container.layer.cornerRadius = 5;
    container.layer.shadowRadius = 2;
    container.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    [self.contentView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"plus"];
    
    [container addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(container);
    }];
}

@end
