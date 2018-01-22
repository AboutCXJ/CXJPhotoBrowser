//
//  CXJPhotoLoadingView.h
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/22.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXJPhotoLoadingView : UIView
@property (nonatomic, assign) CGFloat progress;

- (void)showFail;
- (void)showLoading;
@end
