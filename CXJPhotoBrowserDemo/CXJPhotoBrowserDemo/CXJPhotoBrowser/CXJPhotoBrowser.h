//
//  CXJPhotoBrowser.h
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXJPhoto.h"

@interface CXJPhotoBrowser : UIViewController

@property (nonatomic, assign) NSInteger currentIndex;//当前照片索引


+ (CXJPhotoBrowser *)showWithPhotos:(NSArray<CXJPhoto *> *)photos CurrentIndex:(NSInteger)currentIndex;

+ (CXJPhotoBrowser *)showWithSuperView:(UIView *)superView Photos:(NSArray<CXJPhoto *> *)photos CurrentIndex:(NSInteger)currentIndex;
 
@end
