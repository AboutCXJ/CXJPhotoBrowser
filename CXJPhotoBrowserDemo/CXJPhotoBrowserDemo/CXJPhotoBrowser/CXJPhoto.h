//
//  CXJPhoto.h
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXJPhoto : NSObject

@property (nonatomic, strong) NSURL *url;//地址
@property (nonatomic, strong) UIImage *image;//完整照片
@property (nonatomic, strong) UIImage *placeholder;

@property (nonatomic, assign) NSInteger index;//索引

@end
