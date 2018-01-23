//
//  CXJPhotoView.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "CXJPhotoView.h"
#import "CXJPhoto.h"
#import "CXJPhotoLoadingView.h"
#import "CXJPhotoMacro.h"


#define MaxZoomScale 5.0
#define MinZoomScale 1.0

@interface CXJPhotoView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CXJPhotoLoadingView *loadingView;
@end


@implementation CXJPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer];
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (_loadingView) {
        _loadingView.progress = 0;
        if (_loadingView.superview) {
            [_loadingView removeFromSuperview];
        }
    }
    
}


#pragma mark - handle
- (void)loadPhoto {
    if (self.photo.image) {
        self.imageView.image = self.photo.image;
    }else {
        self.imageView.image = self.photo.placeholder;
        
        
        [self.loadingView showLoading];
        [self addSubview:self.loadingView];
        
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:self.photo.url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            main_sync_safe(^{
                weakSelf.loadingView.progress = (CGFloat)receivedSize/expectedSize;
            });
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            main_sync_safe(^{
                [weakSelf finishLoadImage:image];
            });
        }];
        
        
    }
}

- (void)finishLoadImage:(UIImage *)image {
    if (image) {
        self.imageView.image = image;
        self.photo.image = image;
        if (self.loadingView.superview) {
            [self.loadingView removeFromSuperview];
        }
    }else {
        if (self.loadingView.superview == nil) {
            [self addSubview:self.loadingView];
        }
        [self.loadingView showFail];
    }
    [self adjustImageViewFrame];
}

- (void)adjustImageViewFrame {
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat imageWidth = _imageView.image.size.width;
    CGFloat imageHeight = _imageView.image.size.height;
    
    CGFloat widthScale  = boundsWidth/imageWidth;
    CGFloat heightScale = boundsHeight/imageHeight;
    
    {
        CGFloat scale = MIN(widthScale, heightScale);
//        self.scrollView.maximumZoomScale = 1/scale;
//        self.scrollView.minimumZoomScale = 1;
        if (self.scrollView.zoomScale != 1.0f) {
            self.scrollView.zoomScale = 1.0f;
        }
        
        imageWidth  = imageWidth*scale;
        imageHeight = imageHeight*scale;
        
        CGRect imageFrame = CGRectMake((boundsWidth - imageWidth)*0.5, (boundsHeight - imageHeight)*0.5, imageWidth, imageHeight);
        self.scrollView.contentSize = CGSizeMake(boundsWidth, boundsHeight);
        _imageView.frame = imageFrame;
    }
}


//添加手势
- (void)addGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
}

//单击
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (self.singleTapBlock) {
        self.singleTapBlock(self);
    }
}

//双击
- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        
        CGRect zoomRect;//放大区域
        
        //放大区域的大小由自身大小除以最大放大倍数
        zoomRect.size.height = self.frame.size.height / self.scrollView.maximumZoomScale;
        zoomRect.size.width = self.frame.size.width / self.scrollView.maximumZoomScale;
        
        zoomRect.origin.y = touchPoint.y - (zoomRect.size.height * 0.5);
        zoomRect.origin.x = touchPoint.x - (zoomRect.size.width * 0.5);
        
        [self.scrollView zoomToRect:zoomRect animated:YES];
        
    }else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES
         ];    }
    
    
    
    if (self.doubleTapBlock) {
        self.doubleTapBlock(self);
    }
}

#pragma mark - @protocol UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize cellSize = self.bounds.size;
    CGRect imageViewFrame = self.imageView.frame;
    
    if (imageViewFrame.size.width < cellSize.width) {
        imageViewFrame.origin.x = (cellSize.width - imageViewFrame.size.width) * 0.5;
    }else {
        imageViewFrame.origin.x = 0;
    }
    
    
    if (imageViewFrame.size.height < cellSize.height) {
        imageViewFrame.origin.y = (cellSize.height - imageViewFrame.size.height) * 0.5;
    }else {
        imageViewFrame.origin.y = 0;
    }
    
    self.imageView.frame = imageViewFrame;
}


#pragma mark - get/set
- (void)setPhoto:(CXJPhoto *)photo {
    _photo = photo;
    [self loadPhoto];
    [self adjustImageViewFrame];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator   = NO;
        _scrollView.showsVerticalScrollIndicator     = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.minimumZoomScale = MinZoomScale;
        _scrollView.maximumZoomScale = MaxZoomScale;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (CXJPhotoLoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[CXJPhotoLoadingView alloc] init];
//        _loadingView.hidden = YES;
//        [self addSubview:_loadingView];
    }
    return _loadingView;
}
@end
