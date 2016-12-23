//
//  FDShareViewController.h
//  FirstDemo
//
//  Created by mxl on 16/12/23.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDCity.h"

@interface FDShareViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) FDCity *city;

@end
