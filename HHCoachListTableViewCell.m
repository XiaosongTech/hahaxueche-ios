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
    self.dataView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.dataView.layer.cornerRadius = 5.0f;
    self.dataView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.dataView];
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarView.layer.cornerRadius = kAvatarRadius;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarView.image = [UIImage imageNamed:@"fbAvatar.jpg"];
    [self.dataView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithTitle:@"王子潇" font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:15] color:[UIColor blackColor]];
    self.addressLabel = [self createLabelWithTitle:@"杭州-下城区" font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:12] color:[UIColor grayColor]];
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.addressLabel addGestureRecognizer:tapAddress];
    self.addressLabel.userInteractionEnabled = YES;
    self.priceLabel = [self createLabelWithTitle:@"￥1500" font:[UIFont fontWithName:@"SourceHanSansSC-Heavy" size:16] color:[UIColor darkTextColor]];
    
    self.locationPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    self.locationPin.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tapPin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation)];
    [self.locationPin addGestureRecognizer:tapPin];
    self.locationPin.userInteractionEnabled = YES;
    [self.dataView addSubview:self.locationPin];
    
    self.ratingView = [[HHRatingView alloc] initWithFloat:4.0f interactionEnabled:NO];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataView addSubview:self.ratingView];
    
    NSMutableAttributedString * yearString = [self generateAttributedStringWithString:@"10" font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:14] color:[UIColor blackColor]];
    
    [yearString appendAttributedString:[self generateAttributedStringWithString:@"年教龄" font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:14] color:[UIColor blackColor]]];
    
    
    self.teachedYearLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:14] color:[UIColor blackColor]];
    self.teachedYearLabel.attributedText = yearString;
    
    
    self.teachedStudentAmount = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:14] color:[UIColor blackColor]];
    
    NSMutableAttributedString * studentAmountString = [self generateAttributedStringWithString:@"累计" font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:14] color:[UIColor blackColor]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:@"88" font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:14] color:[UIColor blackColor]]];
    [studentAmountString appendAttributedString:[self generateAttributedStringWithString:@"名学员" font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:14] color:[UIColor blackColor]]];
    self.teachedStudentAmount.attributedText = studentAmountString;
    
    self.courseLabel = [self createLabelWithTitle:@"科目二" font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:11] color:[UIColor whiteColor]];
    self.courseLabel.textAlignment = NSTextAlignmentCenter;
    self.courseLabel.layer.masksToBounds = YES;
    self.courseLabel.layer.cornerRadius = 9.0f;
    self.courseLabel.backgroundColor = [UIColor HHOrange];
    
    self.ratingLabel = [self createLabelWithTitle:@"84 评价" font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:11] color:[UIColor darkGrayColor]];
}

- (NSMutableAttributedString *)generateAttributedStringWithString:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
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
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:10.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.locationPin constant:11.0f],
                             [HHAutoLayoutUtility horizontalNext:self.locationPin toView:self.nameLabel constant:5.0f],
                             [HHAutoLayoutUtility setViewHeight:self.locationPin multiplier:0 constant:20.0f],
                             [HHAutoLayoutUtility setViewWidth:self.locationPin multiplier:0 constant:20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.addressLabel constant:12.0f],
                             [HHAutoLayoutUtility horizontalNext:self.addressLabel toView:self.locationPin constant:0.],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.priceLabel constant:9.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.priceLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingView toView:self.nameLabel constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingView toView:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:110.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.ratingLabel toView:self.nameLabel constant:5.0f],
                             [HHAutoLayoutUtility horizontalNext:self.ratingLabel toView:self.ratingView constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.teachedYearLabel toView:self.ratingView constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.teachedYearLabel toView:self.avatarView constant:10.0f],

                             [HHAutoLayoutUtility verticalNext:self.teachedStudentAmount toView:self.ratingView constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.teachedStudentAmount toView:self.teachedYearLabel constant:15.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.courseLabel toView:self.teachedYearLabel constant:6.0f],
                             [HHAutoLayoutUtility horizontalNext:self.courseLabel toView:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.courseLabel multiplier:0 constant:18.0f],
                             [HHAutoLayoutUtility setViewWidth:self.courseLabel multiplier:0 constant:76.0f],
                             ];
    [self.contentView addConstraints:constraints];
}

- (void)showLocation {
    
}


@end
