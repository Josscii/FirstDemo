//
//  FDEditCityFlowLayout.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDEditCityFlowLayout.h"
#import "FDDeleteDecorationView.h"

@implementation FDEditCityFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
        BOOL editingCity = [[NSUserDefaults standardUserDefaults] boolForKey:@"editingCity"];
        if (attr.indexPath.item == [self numOfItems]-1) {
            attr.hidden = editingCity;
        }
    }
    
    return layoutAttributes;
}

- (NSInteger)numOfItems {
    return [self.collectionView numberOfItemsInSection:0];
}

@end
