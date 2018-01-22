//
//  CXJPhotoView.h
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXJPhoto;

@interface CXJPhotoView : UICollectionViewCell
@property (nonatomic, strong) CXJPhoto *photo;

//单击block
@property (nonatomic, copy) void(^singleTapBlock)(CXJPhotoView *photoView);
- (void)setSingleTapBlock:(void (^)(CXJPhotoView *photoView))singleTapBlock;


//双击block
@property (nonatomic, copy) void(^doubleTapBlock)(CXJPhotoView *photoView);
- (void)setDoubleTapBlock:(void (^)(CXJPhotoView *photoView))doubleTapBlock;
@end
