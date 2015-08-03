//
//  HHReviewTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReviewTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHFormatUtility.h"

@implementation HHReviewTableViewCell

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
    
    self.titleLabel = [self createLabelWithTitle:NSLocalizedString(@"学员评价",nil) font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f] textColor:[UIColor HHGrayTextColor]];
    
    self.ratingView = [[HHRatingView alloc] initWithInteractionEnabled:NO];
    self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.ratingView];
    
    self.ratingLabel = [self createLabelWithTitle:nil font:[UIFont fontWithName:@"SourceHanSansCN-Medium" size:12] textColor:[UIColor HHOrange]];
    
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
    [label sizeToFit];
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
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingView toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.ratingView constant:-25.0f],
                             [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:15.0f],
                             [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:90.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.ratingLabel toView:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.ratingLabel constant:-10.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:0],

                             
                            ];
    [self.contentView addConstraints:constraints];
    
}

- (void)setupRatingView:(NSNumber *)rating {
    [self.ratingView setupViewWithRating:[rating floatValue]];
    self.ratingLabel.text = [[HHFormatUtility floatFormatter] stringFromNumber:rating];
}

@end
