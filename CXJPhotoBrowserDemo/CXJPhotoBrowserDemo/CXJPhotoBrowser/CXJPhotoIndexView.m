//
//  CXJPhotoIndexView.m
//  CXJPhotoBrowserDemo
//
//  Created by sfzx on 2018/1/19.
//  Copyright © 2018年 陈鑫杰. All rights reserved.
//

#import "CXJPhotoIndexView.h"

@interface CXJPhotoIndexView ()
@property (nonatomic, strong) UILabel *indexLB;
@end


@implementation CXJPhotoIndexView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __block typeof(self) weakSelf = self;
    
    [self.indexLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
}

#pragma mark - set/get
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.indexLB.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1, _amount];
}

- (void)setAmount:(NSInteger)amount {
    _amount = amount;
    self.indexLB.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1, _amount];
}


- (UILabel *)indexLB {
    if (_indexLB == nil) {
        _indexLB = [[UILabel alloc] init];
        _indexLB.font = [UIFont systemFontOfSize:15];
        _indexLB.textColor = [UIColor whiteColor];
        _indexLB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_indexLB];
    }
    return _indexLB;
}
@end
