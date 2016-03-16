//
//  HHImageView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 3/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHImageView.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

@interface HHImageView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HHImageView

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1.0f;
        self.scrollView.maximumZoomScale = 3.0f;
        [self addSubview:self.scrollView];
        
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self.width);
            make.height.equalTo(self.height);
        }];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageView sd_setImageWithURL:URL placeholderImage:nil];
        [self.scrollView addSubview:self.imageView];
        
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView.width).offset(-20.0f);
            make.height.equalTo(self.scrollView.height);
        }];

    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


@end
