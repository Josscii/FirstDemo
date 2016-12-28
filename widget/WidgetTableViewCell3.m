//
//  WidgetTableViewCell3.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetTableViewCell3.h"
#import "Masonry.h"
#import "FDConstants.h"

@interface WidgetTableViewCell3 ()

@end

@implementation WidgetTableViewCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self feedFakeData];
    }
    return self;
}

- (void)setupView {
    _notifiLabel = [[UILabel alloc] init];
    _notifiLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _notifiLabel.font = [UIFont fontWithName:PFSCR size:13];
    _notifiLabel.numberOfLines = 0;
    [self.contentView addSubview:_notifiLabel];
    
    [_notifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5.5);
        make.bottom.equalTo(self.contentView).offset(-5.5);
    }];
}

- (void)feedFakeData {
    _notifiLabel.text = @"30分钟之后下小雨，出门记得带伞哟~";
}


@end
