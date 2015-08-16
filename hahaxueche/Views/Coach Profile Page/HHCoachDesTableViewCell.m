//
//  HHCoachDesTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachDesTableViewCell.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HHCoachDesTableViewCell


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
    
    self.avatarView = [[HHAvatarView alloc] initWithImage:nil radius:20.0f borderColor:[UIColor whiteColor]];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapped)];
    [self.avatarView addGestureRecognizer:tap];
    [self.containerView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:15.0f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.nameLabel];
    
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.desLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.desLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Normal" size:13.0f];
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.numberOfLines = 0;
    [self.containerView addSubview:self.desLabel];
    
    [self autoLayoutSubviews];
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.containerView constant:8.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.containerView constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.containerView multiplier:1.0f constant:-8.0f],
                             [HHAutoLayoutUtility setViewWidth:self.containerView multiplier:1.0f constant:-20.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:5.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:8.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:40.0f],
            
                             [HHAutoLayoutUtility setCenterY:self.nameLabel toView:self.avatarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.nameLabel toView:self.avatarView constant:8.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.desLabel toView:self.avatarView constant:1.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.desLabel constant:10.0f],
                             [HHAutoLayoutUtility setViewWidth:self.desLabel multiplier:1.0f constant:-20.0f],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.desLabel constant:-5.0f],

                             ];
    [self.contentView addConstraints:constraints];

}

- (void)setupViewWithURL:(NSString *)url name:(NSString *)name des:(NSMutableAttributedString *)des {
    [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    self.nameLabel.text = name;
    self.desLabel.attributedText = des;
    
}

- (void)avatarViewTapped {
    if (self.block) {
        self.block();
    }
}

@end
