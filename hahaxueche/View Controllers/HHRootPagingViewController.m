//
//  HHRootPagingViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHRootPagingViewController.h"
#import "UIView+HHRect.h"
#import "HHCoachListViewController.h"
#import "HHBookViewController.h"

@implementation HHRootPagingViewController

- (instancetype)init {
    UIImage *coachListImage = [UIImage imageNamed:@"profile"];
    
    UIImageView *coachListView = [[UIImageView alloc] initWithImage:coachListImage];
    coachListView.contentMode = UIViewContentModeScaleAspectFit;
    [coachListView setFrameWithSize:CGSizeMake(35, 35)];
    
    
    UIImageView *reservationView = [[UIImageView alloc] initWithImage:coachListImage];
    reservationView.contentMode = UIViewContentModeScaleAspectFit;
    [reservationView setFrameWithSize:CGSizeMake(35, 35)];
    
    UIImageView *bookView = [[UIImageView alloc] initWithImage:coachListImage];
    bookView.contentMode = UIViewContentModeScaleAspectFit;
    [bookView setFrameWithSize:CGSizeMake(35, 35)];
    
    
    NSArray *barItems = @[coachListView, reservationView, bookView];
    
    NSArray *controllers = @[
                             [[HHCoachListViewController alloc] init],
                             [[HHBookViewController alloc] init],
                             [[HHCoachListViewController alloc] init]];

    self = [super initWithNavBarItems:barItems controllers:controllers showPageControl:NO];
    
    if (self) {
        self.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
        [self setNavigationBarColor:[UIColor clearColor]];
        __weak SLPagingViewController *weakSelf = self;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"哈哈学车";
        titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        [titleLabel sizeToFit];
        
        
        self.pagingViewMoving = ^(NSArray *subviews) {
            [titleLabel removeFromSuperview];
        };
        self.didChangedPage = ^(NSInteger currentPageIndex) {
            int i = 0;
            for(UIImageView *v in barItems) {
                v.image = coachListImage;
                if(i == currentPageIndex) {
                    v.image = [UIImage imageNamed:nil];
                    [titleLabel sizeToFit];
                    [weakSelf.navigationBarView addSubview:titleLabel];
                    CGPoint center = weakSelf.navigationBarView.center;
                    center.y = center.y + 4.0f;
                    titleLabel.center = center;
                }
                i++;
            }
        };
    }
    return self;
}

@end
