//
//  HHCoachScheduleCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/25/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachScheduleCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHAvatarView.h"
#import "HHFormatUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kCellTextColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]

#define kAvatarRadius 25.0f

@implementation HHCoachScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.avatarViews = [NSMutableArray array];
        self.nameButtons = [NSMutableArray array];
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
    
    self.line = [self createLine];
    self.firstVerticalLine = [self createLine];
    self.secondVerticalLine = [self createLine];
    
    self.timeLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.timeLabel];
    self.courseLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.courseLabel];
    self.amountLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.amountLabel];
    
    for (int i = 0; i < 4; i++) {
        HHAvatarView * avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped:)];
        [avatarView addGestureRecognizer:tap];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:avatarView];
        [self.avatarViews addObject:avatarView];
    
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nameButton.frame = CGRectZero;
        nameButton.translatesAutoresizingMaskIntoConstraints = NO;
        [nameButton setTitleColor:[UIColor HHClickableBlue] forState:UIControlStateNormal];
        nameButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f];
        nameButton.tag = i;
        [nameButton addTarget:self action:@selector(nameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:nameButton];
        [self.nameButtons addObject:nameButton];

        
        NSArray *constraints;
        if (i == 0) {
            constraints = @[
                            [HHAutoLayoutUtility verticalAlignToSuperViewTop:avatarView constant:10.0f],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:0.25f constant:0],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2],
                            
                            [HHAutoLayoutUtility verticalNext:nameButton toView:avatarView constant:0],
                            [HHAutoLayoutUtility setCenterX:nameButton multiplier:0.25f constant:0],
                            [HHAutoLayoutUtility setViewHeight:nameButton multiplier:0 constant:30.0],
                            ];
        } else {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:avatarView toView:self.avatarViews[i-1] multiplier:1.0f constant:0],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:0.25f+i*0.5f constant:0],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2],
                            
                            [HHAutoLayoutUtility verticalNext:nameButton toView:avatarView constant:0],
                            [HHAutoLayoutUtility setCenterX:nameButton multiplier:0.25f+i*0.5f constant:0],
                            [HHAutoLayoutUtility setViewHeight:nameButton multiplier:0 constant:30.0],
                            ];
        }
        
        [self addConstraints:constraints];
        
    }
    
    [self autoLayoutSubviews];
    
}

- (UIView *)createLine {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.containerView addSubview:line];
    return line;
}

- (void)avatarViewTapped:(UITapGestureRecognizer *)tap {
    HHAvatarView *view = (HHAvatarView *)tap.view;
    if (view.tag + 1 <= self.students.count) {
        if (self.block) {
            HHStudent *student = self.students[view.tag];
            self.block(student);
        }
    }
}


- (void)setupAvatars {
    for (int i = 0; i < 4; i++) {
        HHAvatarView *avatarView = self.avatarViews[i];
        avatarView.imageView.image = nil;
        UIButton *nameButton = self.nameButtons[i];
        [nameButton setTitle:@"" forState:UIControlStateNormal];

    }
    
    if ([self.schedule.reservedStudents count]) {
        for (int i = 0; i < self.schedule.reservedStudents.count; i++) {
            HHStudent *student = self.students[i];
            HHAvatarView *avatarView = self.avatarViews[i];
            AVFile *file = [AVFile fileWithURL:student.avatarURL];
            NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"];
            [avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailString] placeholderImage:nil];
        
            UIButton *nameButton = self.nameButtons[i];
            [nameButton setTitle:student.fullName forState:UIControlStateNormal];
            [nameButton sizeToFit];
        }
        
    }
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:-40.0f],
                             [HHAutoLayoutUtility setCenterX:self.line multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.timeLabel multiplier:2.0f constant:-20.0f],
                             [HHAutoLayoutUtility setCenterX:self.timeLabel multiplier:0.4f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.courseLabel toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.courseLabel multiplier:1.1f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.amountLabel toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.amountLabel multiplier:1.7f constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.firstVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.firstVerticalLine multiplier:0.8f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.firstVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.firstVerticalLine multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.secondVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.secondVerticalLine multiplier:1.4f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.secondVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.secondVerticalLine multiplier:0 constant:1.0f],
                             
                             ];
    [self.contentView addConstraints:constraints];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    return label;
}

- (void)nameButtonTapped:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag + 1 <= self.students.count) {
        if (self.block) {
            HHStudent *student = self.students[tag];
            self.block(student);
        }

    }
}

- (void)setupViews {
    NSString *startTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.schedule.startDateTime];
    NSString *endTimeString = [[HHFormatUtility timeFormatter] stringFromDate:self.schedule.endDateTime];
    NSString *timeString = [NSString stringWithFormat:@"%@ 到 %@", startTimeString, endTimeString];
    self.timeLabel.text = timeString;
    
    self.courseLabel.text = self.schedule.course;
    
    NSString *amountString = [NSString stringWithFormat:NSLocalizedString(@"已有%ld人", nil), self.schedule.reservedStudents.count];
    self.amountLabel.text = amountString;
    
}

- (void)setStudents:(NSArray *)students {
    _students = students;
    [self setupViews];
    [self setupAvatars];
    
}

@end
