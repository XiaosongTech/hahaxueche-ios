//
//  HHReviewView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReviewView.h"
#import "UIColor+HHColor.h"
#import "HHStudentService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HHAutoLayoutUtility.h"
#import "HHFormatUtility.h"
#import "NSDate+DateTools.h"

#define kAvatarRadius 20.0f

@implementation HHReviewView

- (instancetype)initWithReview:(HHReview *)review {
    self = [super init];
    if (self) {
        self.review = review;
        self.backgroundColor = [UIColor whiteColor];
        [self initSuviews];
    }
    return self;
}

- (void)initSuviews {
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15] textColor:[UIColor blackColor]];
    self.ratingLabel = [self createLabelWithTitle:[[HHFormatUtility floatFormatter] stringFromNumber:self.review.rating] font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:13] textColor:[UIColor HHOrange]];
    
    self.ratingView = [[HHStarRatingView alloc] initWithFrame:CGRectZero rating:[self.review.rating floatValue]];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.ratingView];
    
    self.commentLabel = [self createLabelWithTitle:self.review.comment font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13] textColor:[UIColor blackColor]];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [[HHStudentService sharedInstance] fetchStudentWithId:self.review.studentId completion:^(HHStudent *student, NSError *error) {
        self.nameLabel.text = student.fullName;
        AVFile *file = [AVFile fileWithURL:student.avatarURL];
        NSString *thumbnailString = [file getThumbnailURLWithScaleToFit:YES width:kAvatarRadius * 4 height:kAvatarRadius * 4 quality:100 format:@"png"];
        [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:thumbnailString] placeholderImage:nil];
    }];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHGrayLineColor];
    [self addSubview:self.line];

    self.timeLabel = [self createLabelWithTitle:[NSDate timeAgoSinceDate:self.review.createdAt] font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12]  textColor:[UIColor blackColor]];
    
    [self autoLayoutSubviews];
    
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    [self addSubview:label];
    [label sizeToFit];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius * 2],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius * 2],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:12.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingView toView:self.nameLabel constant:4.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingView toView:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:90.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingLabel toView:self.ratingView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.ratingLabel toView:self.ratingView constant:5.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.timeLabel toView:self.nameLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.timeLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.commentLabel toView:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility horizontalNext:self.commentLabel toView:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.commentLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:0],
                             
                            ];
    [self addConstraints:constraints];
    
}


@end
