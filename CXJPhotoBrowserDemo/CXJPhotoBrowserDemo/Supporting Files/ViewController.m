//
//  ViewController.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CXJPhotoBrowser.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flow;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSString *urlStr in self.datas) {
        CXJPhoto *photo = [[CXJPhoto alloc] init];
        photo.url = [NSURL URLWithString:urlStr];
        [photos addObject:photo];
    }
    
    [CXJPhotoBrowser showWithPhotos:photos CurrentIndex:indexPath.row];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.imageUrl = self.datas.count>indexPath.row?self.datas[indexPath.row]:nil;
    return cell;
}



#pragma mark - lazy
- (UICollectionViewFlowLayout *)flow {
    if (_flow == nil) {
        _flow = [[UICollectionViewFlowLayout alloc] init];
        _flow.itemSize = CGSizeMake(100, 100);
        _flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flow;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = @[@"http://pic71.nipic.com/file/20150707/13559303_233732580000_2.jpg",
        @"http://pic10.nipic.com/20101103/5063545_000227976000_2.jpg",
        @"http://pic24.nipic.com/20120928/6062547_081856296000_2.jpg",
        @"http://pic50.nipic.com/file/20141014/8442159_182826708000_2.jpg",
        @"http://pic14.nipic.com/20110607/6776092_111031284000_2.jpg",
        @"http://pic4.nipic.com/20090811/1547288_100757007_2.jpg",
        @"http://pic25.nipic.com/20121203/213291_135120242136_2.jpg",
        @"http://a0.att.hudong.com/15/08/300218769736132194086202411_950.jpg",
        @"http://pic27.nipic.com/20130310/4499633_163759170000_2.jpg"];
    }
    return _datas;
}

@end
