//
//  HHTimeSlotTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTimeSlotTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHAvatarView.h"
#import "HHFormatUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHCourseProgressStore.h"
#import "HHCourseProgress.h"

#define kCellTextColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]

#define kAvatarRadius 20.0f

@implementation HHTimeSlotTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.avatarViews = [NSMutableArray array];
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
    
    self.progressLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] textColor:[UIColor whiteColor]];
    self.progressLabel.numberOfLines = 0;
    self.progressLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.containerView addSubview:self.progressLabel];
    
    
    self.selectedIndicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectedIndicatorView.hidden = YES;
    self.selectedIndicatorView.backgroundColor = [UIColor HHTransparentOrange];
    [self.containerView addSubview:self.selectedIndicatorView];
    
    self.whiteLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.whiteLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.whiteLine.backgroundColor = [UIColor whiteColor];
    [self.selectedIndicatorView addSubview:self.whiteLine];
    
    self.selectedInfoLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] textColor:[UIColor whiteColor]];
    self.selectedInfoLabel.numberOfLines = 0;
    [self.selectedIndicatorView addSubview:self.selectedInfoLabel];
    
    self.selectedLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f] textColor:[UIColor whiteColor]];
    [self.selectedIndicatorView addSubview:self.selectedLabel];
    
    self.line = [self createLine];
    self.firstVerticalLine = [self createLine];
    self.secondVerticalLine = [self createLine];
    
    self.timeLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.timeLabel];
    self.courseLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.courseLabel];
    self.amountLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:kCellTextColor];
    [self.containerView addSubview:self.amountLabel];
    
    for (int i = 0; i < 4; i++) {
        HHAvatarView * avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
        avatarView.tag = i;
        avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped:)];
        [avatarView addGestureRecognizer:tap];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:avatarView];
        avatarView.imageView.image = [UIImage imageNamed:@"ic_st_add"];
        [self.avatarViews addObject:avatarView];
        
        NSArray *constraints;
        if (i == 0) {
            constraints = @[
                            [HHAutoLayoutUtility verticalAlignToSuperViewTop:avatarView constant:10.0f],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:0.25f constant:-30.0f * 0.125f],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
                            ];
        } else {
            constraints = @[
                            [HHAutoLayoutUtility setCenterY:avatarView toView:self.avatarViews[i-1] multiplier:1.0f constant:0],
                            [HHAutoLayoutUtility setCenterX:avatarView multiplier:(2*i + 1)*0.25f constant:-30.0f * (2*i + 1) * 0.125f],
                            [HHAutoLayoutUtility setViewHeight:avatarView multiplier:0 constant:kAvatarRadius*2],
                            [HHAutoLayoutUtility setViewWidth:avatarView multiplier:0 constant:kAvatarRadius*2]
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
    if (view.tag + 1 > self.students.count) {
        if (self.emptyAvatarblock) {
            self.emptyAvatarblock();
        }
    } else {
        if (self.block) {
            HHStudent *student = self.students[view.tag];
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
    
    self.selectedLabel.text = NSLocalizedString(@"已选中", nil);
    
    [[HHCourseProgressStore sharedInstance] getCourseProgressArrayWithCompletion:^(NSArray *courseProgressArray, NSError *error) {
        if (!error) {
            if (self.schedule.progressNumber) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"progressNumber = %@", self.schedule.progressNumber];
                NSArray *filterArray = [courseProgressArray filteredArrayUsingPredicate:predicate];
                HHCourseProgress *progress = [filterArray firstObject];
                self.progressLabel.text = progress.progressName;
                if ([progress.progressNumber integerValue] % 3 == 0) {
                    self.progressLabel.backgroundColor = [UIColor colorWithRed:0.6 green:0.86 blue:0.86 alpha:1];
                    
                } else if ([progress.progressNumber integerValue] % 3 == 1) {
                    self.progressLabel.backgroundColor = [UIColor HHOrange];
                    
                } else if ([progress.progressNumber integerValue] % 3 == 2) {
                    self.progressLabel.backgroundColor = [UIColor colorWithRed:1 green:0.41 blue:0.49 alpha:1];
                }
                NSString *string = [NSString stringWithFormat:@"%@ %@\n %@（%@）", [[HHFormatUtility dateFormatter] stringFromDate:self.schedule.startDateTime], timeString, self.schedule.course, progress.progressName];
                self.selectedInfoLabel.text = string;
                
            } else {
                self.progressLabel.text = NSLocalizedString(@"无限制", nil);
                self.progressLabel.backgroundColor = [UIColor colorWithRed:0.7 green:0.43 blue:0.93 alpha:1];
                NSString *string = [NSString stringWithFormat:@"%@ %@\n %@（%@）", [[HHFormatUtility dateFormatter] stringFromDate:self.schedule.startDateTime], timeString, self.schedule.course, NSLocalizedString(@"无限制", nil)];
                self.selectedInfoLabel.text = string;
            }
            
        }
    }];
    
}

- (void)setupAvatars {
    for (int i = 0; i < 4; i++) {
        HHAvatarView *avatarView = self.avatarViews[i];
        if (self.hidePlusImage) {
            avatarView.imageView.image = nil;
        } else {
            avatarView.imageView.image = [UIImage imageNamed:@"ic_st_add"];
        }
        
        
    }
    
    if ([self.schedule.reservedStudents count]) {
        for (int i = 0; i < self.schedule.reservedStudents.count; i++) {
            HHStudent *student = self.students[i];
            HHAvatarView *avatarView = self.avatarViews[i];
            AVFile *file = [AVFile fileWithURL:student.avatarURL];
            NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"];
            [avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailString] placeholderImage:nil];
        }

    }
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.progressLabel constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.progressLabel constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.progressLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.progressLabel multiplier:0 constant:30.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.selectedIndicatorView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.selectedIndicatorView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.selectedIndicatorView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.selectedIndicatorView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:-40.0f],
                             [HHAutoLayoutUtility setCenterX:self.line multiplier:1.0f constant:-10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-50.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.timeLabel multiplier:2.0f constant:-20.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.timeLabel constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.timeLabel multiplier:0.5f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.courseLabel toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.courseLabel toView:self.timeLabel constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.courseLabel multiplier:0.25f constant:-5.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.amountLabel toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.amountLabel toView:self.courseLabel constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.amountLabel multiplier:0.25f constant:-5.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.firstVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.firstVerticalLine toView:self.timeLabel constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.firstVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.firstVerticalLine multiplier:0 constant:1.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.secondVerticalLine toView:self.timeLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.secondVerticalLine toView:self.courseLabel constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.secondVerticalLine multiplier:0 constant:25.0f],
                             [HHAutoLayoutUtility setViewWidth:self.secondVerticalLine multiplier:0 constant:1.0f],
                             
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.selectedInfoLabel constant:15.0f],
                             [HHAutoLayoutUtility setCenterX:self.selectedInfoLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.whiteLine toView:self.selectedInfoLabel constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.whiteLine multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.whiteLine multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.whiteLine multiplier:0.8f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.selectedLabel toView:self.whiteLine constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.selectedLabel multiplier:1.0f constant:0],
                             
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

- (void)setStudents:(NSArray *)students {
    _students = students;
    [self setupViews];
    [self setupAvatars];
}

@end
