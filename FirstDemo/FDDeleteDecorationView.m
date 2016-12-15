//
//  FDDeleteDecorationView.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDDeleteDecorationView.h"
#import "FDConstants.h"

@interface FDDeleteDecorationView ()

@property (nonatomic, assign) NSInteger deleteIndex;
@property (nonatomic, strong) UIImageView *deleteButton;

@end

@implementation FDDeleteDecorationView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupView];
//        
//        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingMode:) name:FDShouldEnterEditingModeNotification object:nil];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:FDShouldEnterEditingModeNotification object:nil];
//}
//
//- (void)setupView {
//    _deleteButton = [[UIImageView alloc] initWithFrame:self.bounds];
//    _deleteButton.contentMode = UIViewContentModeScaleAspectFill;
//    _deleteButton.image = [UIImage imageNamed:@"tq-view-ydzs-icon"];
//    _deleteButton.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
//    [_deleteButton addGestureRecognizer:tapGesture];
//    
//    [self addSubview:_deleteButton];
//}
//
//- (void)deleteItem:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:FDShouldDeleteCityCellNotification object:self userInfo:@{@"deleteIndex": @(_deleteIndex)}];
//}
//
//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    [super applyLayoutAttributes:layoutAttributes];
//    
//    _deleteIndex = layoutAttributes.indexPath.item;
//    
//    // ?? change layoutattributes here make it crah
//}

@end
