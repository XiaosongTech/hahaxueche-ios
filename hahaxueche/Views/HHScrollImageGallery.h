//
//  HHScrollImageGallery.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHScrollImageGallery : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSArray *URLStrings;

- (instancetype)initWithURLStrings:(NSArray *)URLStrings;

@end
