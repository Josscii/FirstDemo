//
//  FDSunriseView.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSunriseView.h"
#import "FDConstants.h"

@interface FDSunriseView ()

@property (nonatomic, strong) CAShapeLayer *backgorundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, strong) CALayer *sunImageView;
 
@end

@implementation FDSunriseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
    
    // canculating start point and end point
    CGPoint center = CGPointMake(SCREEN_WIDTH/2, 150);
    
    UIBezierPath *tempPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:144
                                                     startAngle:M_PI // 从 pai 开始
                                                       endAngle:M_PI + M_PI / 15 // 到 pai + pai/15 结束
                                                      clockwise:YES];
    
    // 起点
    _startPoint = tempPath.currentPoint;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:144
                                                    startAngle:M_PI + M_PI / 15 // 从 pai + pai/15 开始
                                                      endAngle: 2 * M_PI - M_PI / 15 // 到 2 * pai - pai/15 结束
                                                     clockwise:YES];
    
    // 终点
    CGPoint endPoint = path.currentPoint;
    
    // 白线 layer
    _backgorundLayer = [[CAShapeLayer alloc] init];
    _backgorundLayer.path = path.CGPath;
    _backgorundLayer.lineDashPattern = @[@6, @2];
    _backgorundLayer.strokeColor = [UIColor whiteColor].CGColor;
    _backgorundLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:_backgorundLayer];
    
    // 黄线 layer
    _progressLayer = [[CAShapeLayer alloc] init];
    _progressLayer.path = path.CGPath;
    _progressLayer.lineDashPattern = @[@6, @2];
    _progressLayer.strokeColor = [UIColor yellowColor].CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    
    [self.layer addSublayer:_progressLayer];
    
    // add two dot
    UIBezierPath *oval = [UIBezierPath bezierPathWithArcCenter:_startPoint
                                                         radius:2
                                                     startAngle:0
                                                       endAngle:2 * M_PI
                                                      clockwise:YES];
    
    CAShapeLayer *dot1 = [[CAShapeLayer alloc] init];
    dot1.path = oval.CGPath;
    dot1.fillColor = [UIColor yellowColor].CGColor;
    
    [self.layer addSublayer:dot1];
    
    UIBezierPath *oval2 = [UIBezierPath bezierPathWithArcCenter:endPoint
                                                        radius:2
                                                    startAngle:0
                                                      endAngle:2 * M_PI
                                                     clockwise:YES];
    
    CAShapeLayer *dot2 = [[CAShapeLayer alloc] init];
    dot2.path = oval2.CGPath;
    dot2.fillColor = [UIColor yellowColor].CGColor;
    
    [self.layer addSublayer:dot2];
    
    // 太阳图片
    _sunImageView = [CALayer layer];
    _sunImageView.frame = CGRectMake(0, 0, 20, 20);
    _sunImageView.contents = (__bridge id)([UIImage imageNamed:@"tq-view-sun-icon"].CGImage);
    _sunImageView.position = _startPoint;
    _sunImageView.opacity = 0;
    [self.layer addSublayer:_sunImageView];
}

- (void)animatedSunRise {
    if ([_currentTime compare:_endTime] == NSOrderedDescending) {
        _sunImageView.opacity = 0;
        
        // workaround: reset the stoke end and position of
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.toValue = 0;
        animation.duration = 0;
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = NO;
        [_progressLayer addAnimation:animation forKey:animation.keyPath];
        
        return;
    } else {
        _sunImageView.position = _startPoint;
        _sunImageView.opacity = 1;
    }
    
    CGFloat propation = [_currentTime timeIntervalSinceDate:_startTime] / [_endTime timeIntervalSinceDate:_startTime];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.toValue = @(propation);
    animation.duration = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    
    [_progressLayer addAnimation:animation forKey:animation.keyPath];
    
    // imageview
    CGPoint center = CGPointMake(SCREEN_WIDTH/2, 150);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:144
                                                    startAngle:M_PI + M_PI / 15
                                                      endAngle:M_PI + M_PI / 15 + (M_PI - (M_PI/15) * 2) * propation
                                                     clockwise:YES];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = path.CGPath;
    keyAnimation.duration = 2;
    keyAnimation.fillMode = kCAFillModeBoth;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.calculationMode =  kCAAnimationPaced;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_sunImageView addAnimation:keyAnimation forKey:keyAnimation.keyPath];
    
    // we don't need this
    //_sunImageView.position = path.currentPoint;
}

@end
