//
//  FdAddCotyCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FdAddCotyCollectionViewCell.h"
#import "Masonry/Masonry.h"

@implementation FdAddCotyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 5;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"plus"];
    
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

@end
