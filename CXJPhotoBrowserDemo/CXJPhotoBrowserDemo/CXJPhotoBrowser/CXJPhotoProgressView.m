//
//  CXJPhotoProgressView.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "CXJPhotoProgressView.h"


#define Progress_Width 3.0f
@interface CXJPhotoProgressView ()
{
    CGFloat add;
    CGAffineTransform _transform;
}
@property (nonatomic, strong) CAShapeLayer *backCircle;//背景圈
@property (nonatomic, strong) CAShapeLayer *progressCircle;//进度圆圈
@property (nonatomic, strong) UIBezierPath *progressPath;//进度路径
@end


@implementation CXJPhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //逆时针90度
        self.transform = CGAffineTransformRotate(self.transform, -M_PI_2);
        _transform = self.transform;
    }
    return self;
}
- (void)layoutSubviews{
    //背景圈
    [self.layer insertSublayer:self.backCircle atIndex:0];
    
    //连接进度路径
    self.progressCircle.path = self.progressPath.CGPath;
    //添加并显示
    [self.layer addSublayer:_progressCircle];
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressCircle.strokeEnd =progress;
}

#pragma mark - set/get

- (CAShapeLayer *)backCircle{
    if (_backCircle == nil) {
        _backCircle =  [CAShapeLayer layer];
        CGMutablePathRef path =  CGPathCreateMutable();
        _backCircle.lineWidth = Progress_Width;
        _backCircle.strokeColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor;
        _backCircle.fillColor = [UIColor clearColor].CGColor;
        CGPathAddEllipseInRect(path, nil, self.bounds);
        _backCircle.path = path;
        CGPathRelease(path);
    }
    return _backCircle;
}

- (CAShapeLayer *)progressCircle{
    if (_progressCircle == nil) {
        //创建出CAShapeLayer
        _progressCircle = [CAShapeLayer layer];
        _progressCircle.frame = self.bounds;
        _progressCircle.fillColor = [UIColor clearColor].CGColor;
        //设置线条的宽度和颜色
        _progressCircle.lineWidth = Progress_Width;
        _progressCircle.strokeColor = [UIColor whiteColor].CGColor;
        //设置stroke起始点
        _progressCircle.strokeStart = 0;
        _progressCircle.strokeEnd = 0;
    }
    return _progressCircle;
}

- (UIBezierPath *)progressPath{
    if (_progressPath == nil) {
        //创建出圆形贝塞尔曲线
        _progressPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    }
    return _progressPath;
}
@end
