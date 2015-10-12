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
    
    self.titleLabel = [self createLabelWithTitle:NSLocalizedString(@"查看教练练车时间",nil) font:[UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f] textColor:[UIColor HHGrayTextColor]];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.arrowImageView];
    
    [self autoLayoutSubviews];
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


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.titleLabel constant:10.0f],
                             
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.arrowImageView constant:-8.0f],
                             [HHAutoLayoutUtility setCenterY:self.arrowImageView multiplier:1.0f constant:0],
                            ];
    [self.contentView addConstraints:constraints];
    
}

@end
