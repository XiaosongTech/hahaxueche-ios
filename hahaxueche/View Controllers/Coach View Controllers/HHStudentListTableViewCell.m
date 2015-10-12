//
//  HHStudentListTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHStudentListTableViewCell.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kAvatartRadius 30.0f

@implementation HHStudentListTableViewCell

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
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 5.0f;
    self.containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.containerView];
    
    self.avatarView = [[HHAvatarView alloc] initWithImageURL:nil radius:kAvatartRadius borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.avatarView];
    
    self.nameLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f] textColor:[UIColor HHDarkGrayTextColor]];
    self.numberLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f] textColor:[UIColor HHGrayTextColor]];
    self.moneyLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0f] textColor:[UIColor HHOrange]];
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:kAvatartRadius * 2],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:kAvatartRadius * 2],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.nameLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToViewBottom:self.numberLabel toView:self.avatarView constant:-5.0f],
                             [HHAutoLayoutUtility horizontalNext:self.numberLabel toView:self.avatarView constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.moneyLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.moneyLabel constant:-10.0f],
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

- (void)setupViewsWithStudent:(HHStudent *)student priceString:(NSString *)priceString {
    [self.avatarView.imageView  sd_setImageWithURL:[NSURL URLWithString:student.avatarURL] placeholderImage:nil];
    self.nameLabel.text = student.fullName;
    self.numberLabel.text = student.phoneNumber;
    self.moneyLabel.text = priceString;
}

@end
