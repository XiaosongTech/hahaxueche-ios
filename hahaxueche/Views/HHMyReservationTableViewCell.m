//
//  HHMyReservationTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMyReservationTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHFormatUtility.h"
#import "HHUserAuthenticator.h"
#import "HHAvatarView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kAvatarRadius 15.0f
#define kCellTextColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]

@implementation HHMyReservationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.avatarViewsArray = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.containerView];
    
    self.timeLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:kCellTextColor];
    
    self.coachNameButton = [self createButtonWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:[UIColor HHClickableBlue] action:@selector(coachNameButtonTapped)];

    self.courseLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:kCellTextColor];
    self.studentsLabel = [self createLabelWithTitle:NSLocalizedString(@"同车学员:", nil) font:[UIFont fontWithName:@"STHeitiSC-Light" size:11.0f] textColor:kCellTextColor];

    self.line = [self createLine];
    self.firstVerticalLine = [self createLine];
    self.secondVerticalLine = [self createLine];
    
    
    for (int i = 0; i < 4; i++) {
        HHAvatarView * avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped:)];
        [avatarView addGestureRecognizer:tap];
        [self.containerView addSubview:avatarView];
        [self.avatarViewsArray addObject:avatarView];
        
        NSArray *constraints;
        if (i == 0) {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:avatarView multiplier:1.5f constant:0],
                            [HHAutoLayoutUtility horizontalNext:avatarView toView:self.studentsLabel constant:10.0f],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
                            ];
        } else {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:avatarView multiplier:1.5f constant:0],
                            [HHAutoLayoutUtility horizontalNext:avatarView toView:self.avatarViewsArray[i-1] constant:10.0f],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
                            ];
        }
        
        [self addConstraints:constraints];
        
    }
    [self autoLayoutSubviews];

}

- (void)avatarViewTapped:(UITapGestureRecognizer *)tap {
    HHAvatarView *view = (HHAvatarView *)tap.view;
    if ([self.students count]) {
        if (self.avatarActionBlock) {
            HHStudent *student = self.students[view.tag];
            self.avatarActionBlock(student);
        }
    }
}

- (void)coachNameButtonTapped {
    if (self.nameButtonBlock) {
        self.nameButtonBlock();
    }
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.line multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.line multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.coachNameButton constant:8.0f],
                             [HHAutoLayoutUtility setCenterX:self.coachNameButton multiplier:1.0f/3.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.timeLabel toView:self.coachNameButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.timeLabel multiplier:1.0f constant:0],

                             [HHAutoLayoutUtility setCenterY:self.courseLabel toView:self.coachNameButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.courseLabel multiplier:5.0f/3.0f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.firstVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.firstVerticalLine multiplier:2.0f/3.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.firstVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.firstVerticalLine multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.secondVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.secondVerticalLine multiplier:4.0f/3.0f constant:0.f],
                             [HHAutoLayoutUtility setViewHeight:self.secondVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.secondVerticalLine multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.studentsLabel constant:20.0f],
                             [HHAutoLayoutUtility setCenterY:self.studentsLabel multiplier:1.5f constant:0],
                             
                             ];
    [self.contentView addConstraints:constraints];
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    [self.containerView addSubview:label];
    return label;
}

- (UIButton *)createButtonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:button];
    return button;
}

- (void)setupViews {
    NSString *startTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.reservation.startDateTime];
    NSString *endTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.reservation.endDateTime];
    NSString *timeString = [NSString stringWithFormat:@"%@ 到 %@", startTimeString, endTimeString];
    self.timeLabel.text = timeString;
    
    NSString *nameString = [NSString stringWithFormat:@"%@ 教练", [HHUserAuthenticator sharedInstance].myCoach.fullName];
    NSMutableAttributedString *attrNameString = [[NSMutableAttributedString alloc] initWithString:nameString];
    [attrNameString addAttributes:@{
                                    NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f],
                                    NSForegroundColorAttributeName:[UIColor HHClickableBlue],
                                    }
                            range:NSMakeRange(0, nameString.length - 2)];
    
    [attrNameString addAttributes:@{
                                    NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f],
                                    NSForegroundColorAttributeName:kCellTextColor,
                                    }
                            range:NSMakeRange(nameString.length - 2, 2)];
    
    [self.coachNameButton setAttributedTitle:attrNameString forState:UIControlStateNormal];
    
    self.courseLabel.text = self.reservation.course;
    
    
    for (HHStudent *student in self.students) {
        if ([student.studentId isEqualToString:[HHUserAuthenticator sharedInstance].currentStudent.studentId]) {
            [self.students removeObject:student];
        }
    }
    for (int i = 0; i < self.students.count; i++) {
        HHStudent *student = self.students[i];
        AVFile *file = [AVFile fileWithURL:student.avatarURL];
        HHAvatarView *avatarView = self.avatarViewsArray[i];
        [avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"]] placeholderImage:nil];
    }
    self.studentsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"同车学员(%ld):", nil), self.students.count];
}

- (UIView *)createLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.containerView addSubview:line];
    return line;
}



@end
