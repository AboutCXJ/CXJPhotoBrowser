//
//  CXJPhotoBrowser.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "CXJPhotoBrowser.h"
#import "CXJPhotoView.h"
#import "CXJPhotoIndexView.h"
#import "CXJPhotoMacro.h"


@interface CXJPhotoBrowser ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) CXJPhotoIndexView *indexView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flow;
@property (nonatomic, strong) NSArray<CXJPhoto *> *photos;//所以图片对象
@property (nonatomic, assign) BOOL isFirstLoad;//第一次进入
@end


@implementation CXJPhotoBrowser


+ (CXJPhotoBrowser *)showWithPhotos:(NSArray<CXJPhoto *> *)photos CurrentIndex:(NSInteger)currentIndex {
    return [self showWithSuperView:nil Photos:photos CurrentIndex:currentIndex];
}

+ (CXJPhotoBrowser *)showWithSuperView:(UIView *)superView Photos:(NSArray<CXJPhoto *> *)photos CurrentIndex:(NSInteger)currentIndex {
    if (superView == nil) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    
    CXJPhotoBrowser *photoBrowser = [[CXJPhotoBrowser alloc] init];
    photoBrowser.photos = photos;
    
//    photoBrowser.view.alpha = 0.0;
//    photoBrowser.view.frame = superView.bounds;
//    [superView addSubview:photoBrowser.view];
//
    photoBrowser.indexView.amount = photos.count;
    photoBrowser.indexView.currentIndex = currentIndex;
    photoBrowser.currentIndex =currentIndex;
//
//    [UIView animateWithDuration:0.2 animations:^{
//        photoBrowser.view.alpha = 1.0;
//    }];
    
    photoBrowser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[photoBrowser topPresentedViewController] presentViewController:photoBrowser animated:YES completion:nil];
    return photoBrowser;
    
}

- (void)dismiss {
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.2 animations:^{
//        weakSelf.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [weakSelf.view removeFromSuperview];
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoad = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view);
    }];

    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Screen_Width, 30));
        make.left.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(20);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.isFirstLoad) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    self.isFirstLoad = NO;
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//}


#pragma mark - handle

- (void)processCellClickEventWithCell:(CXJPhotoView *)cell {
    
    __block typeof(self) weakSelf = self;
    [cell setSingleTapBlock:^(CXJPhotoView *photoView) {
        [weakSelf dismiss];
    }];
    
    [cell setDoubleTapBlock:^(CXJPhotoView *photoView) {
        
    }];
}


- (UIViewController *)topPresentedViewController{
    UIViewController *ctr   = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *next  = ctr.presentedViewController;
    while (next != nil && !next.isBeingDismissed) {
        ctr     = next;
        next    = ctr.presentedViewController;
    }
    return ctr;
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CXJPhotoView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CXJPhotoView" forIndexPath:indexPath];
    [self processCellClickEventWithCell:cell];
    cell.photo = self.photos.count>indexPath.row?self.photos[indexPath.row]:nil;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page  = (int)scrollView.contentOffset.x/(int)_collectionView.frame.size.width;
    NSInteger delx  = (int)scrollView.contentOffset.x%(int)_collectionView.frame.size.width;
    
    if (delx > _collectionView.frame.size.width *0.5f) {
        page ++;
    }
    if (_currentIndex != page && page < _photos.count) {
        _currentIndex = page;
        self.indexView.currentIndex = page;
    }
}

#pragma mark - lazy
- (void)setPhotos:(NSArray<CXJPhoto *> *)photos {
    _photos = photos;
    
    if (_photos.count <= 0) {
        return;
    }
    for (NSInteger i=0; i<photos.count; i++) {
        photos[i].index = i;
    }
    
    [self.collectionView reloadData];
}

- (CXJPhotoIndexView *)indexView {
    if (_indexView == nil) {
        _indexView = [[CXJPhotoIndexView alloc] init];
        [self.view addSubview:_indexView];
    }
    return _indexView;
}

- (UICollectionViewFlowLayout *)flow {
    if (_flow == nil) {
        _flow = [[UICollectionViewFlowLayout alloc] init];
        _flow.itemSize = CGSizeMake(Screen_Width, Screen_Height);
        _flow.minimumLineSpacing = 0;
        _flow.minimumInteritemSpacing = 0;
        _flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flow;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flow];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CXJPhotoView class] forCellWithReuseIdentifier:@"CXJPhotoView"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
