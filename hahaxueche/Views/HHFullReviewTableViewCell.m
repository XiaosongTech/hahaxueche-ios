//
//  HHFullReviewTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHFullReviewTableViewCell.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import "HHStudentService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHFormatUtility.h"
#import "NSDate+DateTools.h"

#define kAvatarRadius 20.0f

@implementation HHFullReviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSuviews];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)initSuviews {
    self.avatarView = [[HHAvatarView alloc] initWithImage:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15] textColor:[UIColor whiteColor]];
    self.ratingLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:13] textColor:[UIColor HHOrange]];
    
    self.ratingView = [[HHRatingView alloc] initWithInteractionEnabled:NO];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.ratingView];
    
    self.commentLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13] textColor:[UIColor whiteColor]];
    self.commentLabel.numberOfLines = 0;
    
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHGrayLineColor];
    [self.contentView addSubview:self.line];
    
    self.timeLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] textColor:[UIColor whiteColor]];
    
    [self autoLayoutSubviews];
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    [self.contentView addSubview:label];
    [label sizeToFit];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:20.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:15.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius * 2],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius * 2],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:20.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingView toView:self.nameLabel constant:5.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingView toView:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:90.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingLabel toView:self.ratingView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.ratingLabel toView:self.ratingView constant:3.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.timeLabel toView:self.nameLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.timeLabel constant:-15.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.commentLabel toView:self.avatarView constant:1.0f],
                             [HHAutoLayoutUtility horizontalNext:self.commentLabel toView:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.commentLabel constant:-15.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:15.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:0.5f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-30.0f],
                             
                             ];
    [self addConstraints:constraints];
    
}

- (void)setupViews:(HHReview *)review {
    [self.ratingView setupViewWithRating:[review.rating floatValue]];
    self.ratingLabel.text = [[HHFormatUtility floatFormatter] stringFromNumber:review.rating];
    self.commentLabel.text = review.comment;
    self.timeLabel.text = [NSDate timeAgoSinceDate:review.createdAt];
    
    [[HHStudentService sharedInstance] fetchStudentsWithId:review.studentId completion:^(HHStudent *student, NSError *error) {
        [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:nil];
        self.nameLabel.text = student.fullName;
    }];
    
}


@end
