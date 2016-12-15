//
//  FDEditCityCollectionViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDDeleteButton.h"

@protocol FDEditCityCollectionViewCellDelegate <NSObject>

- (void)deleteCell:(UICollectionViewCell *)cell;

@end

@interface FDEditCityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *checkIcon;
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) FDDeleteButton *deleteButton;

@property (nonatomic, weak) id<FDEditCityCollectionViewCellDelegate> delegate;

- (void)configreCellWithData:(id)data;

@end