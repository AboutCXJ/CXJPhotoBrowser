//
//  CXJPhotoLoadingView.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/22.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "CXJPhotoLoadingView.h"
#import "CXJPhotoProgressView.h"
#import "CXJPhotoMacro.h"

@interface CXJPhotoLoadingView ()
@property (nonatomic, strong) UILabel *failLB;
@property (nonatomic, strong) CXJPhotoProgressView *progressView;
@end

@implementation CXJPhotoLoadingView


- (void)setFrame:(CGRect)frame {
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block typeof(self) weakSelf = self;
    
    [self.failLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(Screen_Width_scale*40, Screen_Width_scale*40));
    }];
}


- (void)showFail {
    self.failLB.hidden = NO;
    self.progressView.hidden = YES;
}


- (void)showLoading {
    self.failLB.hidden = YES;
    self.progressView.hidden = NO;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressView.progress = progress;
    if (progress >= 1.0) {
        self.progressView.hidden = YES;
    }
    
}

- (UILabel *)failLB {
    if (_failLB == nil) {
        _failLB = [[UILabel alloc] init];
        _failLB.textAlignment = NSTextAlignmentCenter;
        _failLB.center = self.center;
        _failLB.text = @"网络不给力，图片下载失败";
        _failLB.font = [UIFont boldSystemFontOfSize:20];
        _failLB.textColor = [UIColor whiteColor];
        _failLB.backgroundColor = [UIColor clearColor];
        [self addSubview:_failLB];
    }
    return _failLB;
}

- (CXJPhotoProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[CXJPhotoProgressView alloc] init];
        [self addSubview:_progressView];
    }
    return _progressView;
}
@end
