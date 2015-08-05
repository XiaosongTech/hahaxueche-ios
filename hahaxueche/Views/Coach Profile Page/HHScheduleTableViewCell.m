//
//  HHScheduleTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/1/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScheduleTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHUserAuthenticator.h"
#import "HHToastUtility.h"

@implementation HHScheduleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    
    self.titleLabel = [self createLabelWithTitle:NSLocalizedString(@"可选时间",nil) font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f] textColor:[UIColor HHGrayTextColor]];
    self.subtitleLabel = [self createLabelWithTitle:NSLocalizedString(@"(每一时间段最多4人)", nil) font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f] textColor:[UIColor blackColor]];
    
    self.bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bookButton setTitle:NSLocalizedString(@"预约",nil) forState:UIControlStateNormal];
    [self.bookButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
    [self.bookButton setTitleColor:[UIColor HHOrange] forState:UIControlStateHighlighted];
    [self.bookButton addTarget:self action:@selector(bookTime) forControlEvents:UIControlEventTouchUpInside];
    self.bookButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f];
    [self.containerView addSubview:self.bookButton];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.arrowImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookTime)];
    [self.arrowImageView addGestureRecognizer:tap];
    [self.containerView addSubview:self.arrowImageView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.containerView addSubview:self.line];
    
    [self autoLayoutSubviews];
}

- (void)bookTime {
    if ([[HHUserAuthenticator sharedInstance].currentStudent.myCoachId isEqualToString:self.coach.coachId]) {
        if (self.bookButtonBlock) {
            self.bookButtonBlock();
        }
    } else {
        [HHToastUtility showToastWitiTitle:@"确认教练并付费后才能预约" isError:YES];
    }
}

- (void)setSchedules:(NSArray *)schedules {
    _schedules = schedules;
    if (self.scheduleView) {
        [self.scheduleView removeFromSuperview];
        self.scheduleView = nil;
    }
    self.scheduleView = [[HHSegmentedView alloc] initWithSchedules:self.schedules block:self.block];
    self.scheduleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.scheduleView];
    [self autoLayoutScheduleView];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    [self.containerView addSubview:label];
    return label;
}

- (void)autoLayoutScheduleView {
    NSArray *constraints = @[
                            [HHAutoLayoutUtility verticalNext:self.scheduleView toView:self.line constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.scheduleView constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.scheduleView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.scheduleView multiplier:1.0f constant:0]
                             
                             ];
    [self.contentView addConstraints:constraints];
    
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.titleLabel constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.subtitleLabel toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.subtitleLabel toView:self.titleLabel constant:5.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.bookButton toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.bookButton constant:-25.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.arrowImageView toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.arrowImageView constant:-8.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.line toView:self.titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:0],
                            ];
    [self.contentView addConstraints:constraints];
    
}

@end
