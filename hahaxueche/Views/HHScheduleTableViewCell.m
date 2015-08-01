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
    
    self.titleLabel = [self createLabelWithTitle:NSLocalizedString(@"可选时间",nil) font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f] textColor:[UIColor HHGrayTextColor]];
    self.subtitleLabel = [self createLabelWithTitle:NSLocalizedString(@"(每一时间段最多容纳4人)", nil) font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f] textColor:[UIColor blackColor]];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHLightGrayBackgroundColor];
    [self.containerView addSubview:self.line];
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
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.titleLabel constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.subtitleLabel toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.subtitleLabel toView:self.titleLabel constant:5.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.line toView:self.titleLabel constant:15.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:0],
                             ];
    [self.contentView addConstraints:constraints];
    
}

@end
