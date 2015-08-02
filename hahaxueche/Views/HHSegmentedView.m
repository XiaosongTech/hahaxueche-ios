//
//  HHSegmentedView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHSegmentedView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"

#define kSegmentedControlHeight 40.0f

@implementation HHSegmentedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentedControl.selectedSegmentIndex = 1;
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName: [UIColor HHGrayTextColor],
                                                  NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                                  };
    
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHOrange]};
    self.segmentedControl.selectionIndicatorColor = [UIColor HHOrange];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.bounds) * index, 0, CGRectGetWidth(weakSelf.bounds), CGRectGetHeight(weakSelf.bounds)-kSegmentedControlHeight) animated:YES];
    }];
    [self addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self addSubview:self.scrollView];
    
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.segmentedControl constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.segmentedControl constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.segmentedControl multiplier:0 constant:kSegmentedControlHeight],
                             [HHAutoLayoutUtility setViewWidth:self.segmentedControl multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.scrollView toView:self.segmentedControl constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.scrollView constant:10.0f],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.scrollView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.scrollView multiplier:1.0f constant:0],
                            ];
    [self addConstraints:constraints];
}

- (void)layoutSubviews {
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*self.schedules.count, CGRectGetHeight(self.bounds)-kSegmentedControlHeight);
}

- (void)setupViewsWithSchedules:(NSArray *)schedules {
    self.segmentedControl.sectionTitles = @[@"6月10日\n周二",@"6月11日\n周三",@"6月11日\n周三", @"6月10日\n周二",@"6月11日\n周三",@"6月11日\n周三",@"6月10日\n周二",@"6月11日\n周三",@"6月11日\n周三"];
}

@end
