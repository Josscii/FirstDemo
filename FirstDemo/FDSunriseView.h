//
//  FDSunriseView.h
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSunriseView : UIView

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *currentTime;

- (void)animatedSunRise;

@end
