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
    if (currentCityCount >= 9) {
        layoutAttributes[9].hidden = YES;
        return layoutAttributes;
    }
    
    BOOL editingCity = [[NSUserDefaults standardUserDefaults] boolForKey:EDITINGCITY];
    layoutAttributes[currentCityCount].hidden = editingCity;
    
    return layoutAttributes;
}

@end
