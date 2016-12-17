//
//  FDEditCityFlowLayout.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDEditCityFlowLayout.h"
#import "FDConstants.h"

@implementation FDEditCityFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    NSInteger currentCityCount = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENTCITYCOUNT];
    BOOL editingCity = [[NSUserDefaults standardUserDefaults] boolForKey:EDITINGCITY];
    
    // 只要 = 9 + 号就 hidden
    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
        if (currentCityCount >= 9) {
            if (attr.indexPath.item == 9) {
                attr.hidden = YES;
                break;
            }
        } else {
            if (editingCity) {
                if (attr.indexPath.item == currentCityCount) {
                    attr.hidden = YES;
                }
            } else {
                if (attr.indexPath.item == currentCityCount) {
                    attr.hidden = NO;
                }
            }
        }
    }
    
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
