//
//  HHScrollImageGallery.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHScrollImageGalleryDelegate <NSObject>

@required
-(void)showFullImageView:(NSInteger)index;

@end

@interface HHScrollImageGallery : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak)   id<HHScrollImageGalleryDelegate> delegate;

- (instancetype)initWithURLStrings:(NSArray *)URLStrings;

@end
