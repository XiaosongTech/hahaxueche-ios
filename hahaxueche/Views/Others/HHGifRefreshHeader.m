//
//  HHGifRefreshHeader.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGifRefreshHeader.h"

@implementation HHGifRefreshHeader

- (void)prepare {
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    self.imgView = [[FLAnimatedImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgView];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.imgView.frame = self.bounds;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}



@end
