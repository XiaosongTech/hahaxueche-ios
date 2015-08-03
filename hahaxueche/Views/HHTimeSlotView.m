//
//  HHTimeSlotView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTimeSlotView.h"
#import "HHFormatUtility.h"
#import "HHAutoLayoutUtility.h"
#import "HHStudentService.h"
#import "HHAvatarView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kAvatarRadius 20.0f

@interface HHTimeSlotView ()

@property (nonatomic, strong) NSMutableArray *avatarViews;
@property (nonatomic, strong) NSArray *students;

@end

@implementation HHTimeSlotView

#define kBackgroundColor [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1]

-(instancetype)initWithSchedule:(HHCoachSchedule *)schedule {
    self = [super init];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        self.schedule = schedule;
        self.avatarViews = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    NSString *startTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.schedule.startDateTime];
    NSString *endTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.schedule.endDateTime];
    NSString *timeString = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    self.timeLabel = [self createLabelWithTitle:timeString font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:11.0f] textColor:[UIColor blackColor]];
    self.courseLabel = [self createLabelWithTitle:self.schedule.course font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:13.0f] textColor:[UIColor blackColor]];
    
    for (int i = 0; i < self.schedule.reservedStudents.count; i++) {
        HHAvatarView * avatarView = [[HHAvatarView alloc] initWithImage:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped:)];
        [avatarView addGestureRecognizer:tap];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:avatarView];
        [self.avatarViews addObject:avatarView];
    }
    [[HHStudentService sharedInstance] fetchStudentsForScheduleWithIds:self.schedule.reservedStudents completion:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.students = objects;
            for (int i = 0;  i < self.students.count; i++) {
                HHAvatarView *avatarView = self.avatarViews[i];
                HHStudent *student = self.students[i];
                [avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:nil];
            }
        }
    }];
    [self autoLayoutSubviews];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    [label sizeToFit];
    [self addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.timeLabel constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.timeLabel constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.courseLabel constant:-5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.courseLabel constant:10.0f],
                             
                             ];
    [self addConstraints:constraints];
    
    for (int j = 0; j < self.avatarViews.count; j++) {
        HHAvatarView *view = self.avatarViews[j];
        NSArray *constraints = nil;
        
        if (j == 0) {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:view multiplier:1.0f constant:0],
                            [HHAutoLayoutUtility horizontalNext:view toView:self.timeLabel constant:8.0f],
                            [HHAutoLayoutUtility setViewHeight:view multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:view multiplier:0 constant:kAvatarRadius*2]
                            ];
        } else {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:view multiplier:1.0f constant:0],
                            [HHAutoLayoutUtility horizontalNext:view toView:self.avatarViews[j-1] constant:8.0f],
                            [HHAutoLayoutUtility setViewHeight:view multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:view multiplier:0 constant:kAvatarRadius*2]
                            ];
        }
        
        
        [self addConstraints:constraints];

    }

}

- (void)avatarViewTapped:(UITapGestureRecognizer *)tap {
    HHAvatarView *view = (HHAvatarView *)tap.view;
    if (self.block) {
        HHStudent *student = self.students[view.tag];
        self.block(student);
    }
}

@end
