//
//  HHCoachListTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachListTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <pop/POP.h>
#import "UIColor+HHColor.h"
#import <QuartzCore/QuartzCore.h>
#import "HHNumberFormatUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kDataViewBackgroundColor [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]
#define kAvatarRadius 30.0f


@implementation HHCoachListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self initSubviews];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.dataView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataView.backgroundColor = [UIColor whiteColor];
    self.dataView.layer.cornerRadius = 5.0f;
    self.dataView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.dataView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImage:nil radius:kAvatarRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15] color:[UIColor blackColor]];
    self.addressLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] color:[UIColor grayColor]];
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.addressLabel addGestureRecognizer:tapAddress];
    self.addressLabel.userInteractionEnabled = YES;
    self.priceLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:16] color:[UIColor darkTextColor]];
    
    self.locationPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    self.locationPin.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tapPin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.locationPin addGestureRecognizer:tapPin];
    self.locationPin.userInteractionEnabled = YES;
    [self.dataView addSubview:self.locationPin];
    
    self.ratingView = [[HHRatingView alloc] initWithInteractionEnabled:NO];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView addSubview:self.ratingView];
    
    NSMutableAttributedString * yearString = [self generateAttributedStringWithString:@"10 " font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:14] color:[UIColor blackColor]];
    
    [yearString appendAttributedString:[self generateAttributedStringWithString:@"年教龄" font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] color:[UIColor blackColor]]];
    
    
    self.teachedYearLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:14] color:[UIColor blackColor]];
    
    self.teachedStudentAmount = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:14] color:[UIColor blackColor]];
    
    self.courseLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:11] color:[UIColor whiteColor]];
    self.courseLabel.textAlignment = NSTextAlignmentCenter;
    self.courseLabel.layer.masksToBounds = YES;
    self.courseLabel.layer.cornerRadius = 8.0f;
    self.courseLabel.backgroundColor = [UIColor HHOrange];
    
    self.ratingLabel = [self createLabelWithFont:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12] color:[UIColor HHOrange]];
}

- (NSMutableAttributedString *)generateAttributedStringWithString:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (UILabel *)createLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    [self.dataView addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.dataView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.dataView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.dataView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dataView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatarRadius*2],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:12.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.locationPin constant:10.0f],
                             [HHAutoLayoutUtility horizontalNext:self.locationPin toView:self.nameLabel constant:8.0f],
                             [HHAutoLayoutUtility setViewHeight:self.locationPin multiplier:0 constant:17.5f],
                             [HHAutoLayoutUtility setViewWidth:self.locationPin multiplier:0 constant:11.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.addressLabel constant:12.0f],
                             [HHAutoLayoutUtility horizontalNext:self.addressLabel toView:self.locationPin constant:2.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.priceLabel constant:11.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.priceLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingView toView:self.nameLabel constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingView toView:self.avatarView constant:9.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:100.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingLabel toView:self.ratingView multiplier:1.0f constant:1.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingLabel toView:self.ratingView constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.teachedYearLabel toView:self.ratingView constant:8.0f],
                             [HHAutoLayoutUtility horizontalNext:self.teachedYearLabel toView:self.avatarView constant:10.0f],

                             [HHAutoLayoutUtility setCenterY:self.teachedStudentAmount toView:self.teachedYearLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.teachedStudentAmount toView:self.teachedYearLabel constant:15.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.courseLabel toView:self.teachedYearLabel constant:8.0f],
                             [HHAutoLayoutUtility horizontalNext:self.courseLabel toView:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.courseLabel multiplier:0 constant:76.0f],
                             [HHAutoLayoutUtility setViewHeight:self.courseLabel multiplier:0 constant:16.0f],
                             ];
    [self.contentView addConstraints:constraints];
}

- (void)showLocation {
    
}

- (void)setupCellWithCoach:(HHCoach *)coach {
    [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:coach.avatarURL]
                      placeholderImage:nil];
    self.nameLabel.text = coach.fullName;
    self.priceLabel.text = [[HHNumberFormatUtility moneyFormatter] stringFromNumber:coach.price];
    [self.ratingView setupViewWithRating:[coach.averageRating floatValue]];
    self.ratingLabel.text = [[HHNumberFormatUtility floatFormatter] stringFromNumber:coach.averageRating];;
    
    NSMutableAttributedString * yearString = [self generateAttributedStringWithString:coach.experienceYear font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:14] color:[UIColor blackColor]];
    [yearString appendAttributedString:[self generateAttributedStringWithString:@"年教龄" font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] color:[UIColor blackColor]]];
    self.teachedYearLabel.attributedText = yearString;
    
    NSMutableAttributedString * studentAmountString = [self generateAttributedStringWithString:@"累计" font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] color:[UIColor blackColor]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:@"88" font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:14] color:[UIColor blackColor]]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:@"名学员" font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12] color:[UIColor blackColor]]];
    self.teachedStudentAmount.attributedText = studentAmountString;
    self.courseLabel.text = coach.course;
}


@end
