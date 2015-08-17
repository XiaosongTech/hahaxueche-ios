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

#define kAvatarRadius 20.0f

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
    
    self.timeLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:15.0f] textColor:[UIColor HHGrayTextColor]];
    
    self.coachNameButton = [self createButtonWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:15.0f] textColor:[UIColor HHClickableBlue] action:@selector(coachNameButtonTapped)];

    self.courseLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:15.0f] textColor:[UIColor HHGrayTextColor]];

    
    for (int i = 0; i < 4; i++) {
        HHAvatarView * avatarView = [[HHAvatarView alloc] initWithImage:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:avatarView];
        [self.avatarViewsArray addObject:avatarView];
        
        NSArray *constraints;
        if (i == 0) {
            constraints = @[
                            [HHAutoLayoutUtility verticalAlignToSuperViewBottom:avatarView constant:-10.0f],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:0.25f constant:0],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
                            ];
        } else {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:avatarView toView:self.avatarViewsArray[i-1] multiplier:1.0f constant:0],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:0.25f+i*0.5f constant:0],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
                            ];
        }
        
        [self addConstraints:constraints];
        
    }
    [self autoLayoutSubviews];

}


//-(void)addressButtonTapped {
//    if (self.addressButtonBlock) {
//        self.addressButtonBlock();
//    }
//}

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
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.timeLabel constant:15],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.timeLabel constant:15.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.coachNameButton toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.coachNameButton toView:self.timeLabel constant:20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.courseLabel toView:self.coachNameButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.courseLabel toView:self.coachNameButton constant:20.0f],
                             
                             ];
    [self.contentView addConstraints:constraints];
    
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
    [self.coachNameButton setTitle:nameString forState:UIControlStateNormal];
    
    self.courseLabel.text = self.reservation.course;
    
    for (int i = 0; i < self.students.count; i++) {
        HHStudent *student = self.students[i];
        AVFile *file = [AVFile fileWithURL:student.avatarURL];
        HHAvatarView *avatarView = self.avatarViewsArray[i];
        [avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"]] placeholderImage:nil];
    }
}


@end
