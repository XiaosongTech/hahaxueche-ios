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
#import "HHFormatUtility.h"

#define kSegmentedControlHeight 35.0f

@implementation HHSegmentedView

- (instancetype)initWithSchedules:(NSArray *)schedules block:(AvatarTappedBlock)block {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.schedules = schedules;
        self.block = block;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentedControl.selectedSegmentIndex = 0;
    if (self.schedules) {
         self.segmentedControl.sectionTitles = [self groupSchedulesTitle];
    }
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName: [UIColor HHGrayTextColor],
                                                  NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
                                                  };
    
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor HHOrange]};
    self.segmentedControl.selectionIndicatorColor = [UIColor HHOrange];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView setContentOffset:CGPointMake(CGRectGetWidth(weakSelf.scrollView.bounds) * index, 0) animated:YES];
    }];
    [self addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    [self addSubview:self.scrollView];
    [self setupScrollView];
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.segmentedControl constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.segmentedControl constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.segmentedControl multiplier:0 constant:kSegmentedControlHeight],
                             [HHAutoLayoutUtility setViewWidth:self.segmentedControl multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.scrollView toView:self.segmentedControl constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.scrollView constant:10.0f],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.scrollView constant:-10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.scrollView multiplier:1.0f constant:-20.0f],
                            ];
    [self addConstraints:constraints];
}

- (void)layoutSubviews {
    self.scrollView.contentSize = CGSizeMake((CGRectGetWidth(self.bounds)-20.0f) * self.groupedSchedules.count, CGRectGetHeight(self.scrollView.bounds)-kSegmentedControlHeight);
}


- (NSArray *)groupSchedulesTitle {
    NSMutableArray *array = [NSMutableArray array];
    HHCoachSchedule *firstSchedule = [self.schedules firstObject];
    NSDate *previousDate = firstSchedule.startDateTime;
    NSMutableArray *currentGroup = [NSMutableArray array];
    [currentGroup addObject:firstSchedule];
    for (int i = 1; i < self.schedules.count; i++) {
        HHCoachSchedule *schedule = self.schedules[i];
        if ([[[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime] isEqualToString:[[HHFormatUtility dateFormatter] stringFromDate:previousDate]]) {
            [currentGroup addObject:schedule];
        } else {
            [array addObject:currentGroup];
            currentGroup = [NSMutableArray array];
            [currentGroup addObject:schedule];
        }
        if (i == self.schedules.count - 1) {
            [array addObject:currentGroup];
        }
    }
    self.groupedSchedules = array;
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.groupedSchedules.count; i++) {
        HHCoachSchedule *schedule = [self.groupedSchedules[i] firstObject];
        NSString *date = [[HHFormatUtility dateFormatter] stringFromDate:schedule.startDateTime];
        NSString *title = [NSString stringWithFormat:@"%@\n%@", date, [[HHFormatUtility weekDayFormatter] stringFromDate:schedule.startDateTime]];
        [titles addObject:title];
    }
    return titles;
}

- (void)setupScrollView {
    for (int i = 0; i < self.groupedSchedules.count; i++) {
        NSArray *array = self.groupedSchedules[i];
        for (int j = 0; j < array.count; j++) {
            HHTimeSlotView *timeSlot = [[HHTimeSlotView alloc] initWithSchedule:array[j]];
            timeSlot.translatesAutoresizingMaskIntoConstraints = NO;
            timeSlot.block = self.block;
            [self.scrollView addSubview:timeSlot];
            NSArray *constraints = @[
                                     [HHAutoLayoutUtility setCenterX:timeSlot multiplier:1.0f + 2.0f * i constant:0],
                                     [HHAutoLayoutUtility setCenterY:timeSlot multiplier:0.5f + j constant:0],
                                     [HHAutoLayoutUtility setViewHeight:timeSlot multiplier:0.5f constant:-5.0f],
                                     [HHAutoLayoutUtility setViewWidth:timeSlot multiplier:1.0f constant:-10.],
                                     
                                     ];
            [self addConstraints:constraints];
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

@end
