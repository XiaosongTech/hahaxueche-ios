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

#define kDataViewBackgroundColor [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]

@implementation HHCoachListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.divideLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.divideLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.divideLine.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.divideLine];
    
    self.dataView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataView.backgroundColor = kDataViewBackgroundColor;
    self.dataView.layer.cornerRadius = 5.0f;
    self.dataView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.dataView];
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.avatarView.layer.cornerRadius = 34.0f;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.image = [UIImage imageNamed:@"ava"];
    [self.dataView addSubview:self.avatarView];
    
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.dataView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.dataView constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.dataView multiplier:1.0f constant:-12.0f],
                             [HHAutoLayoutUtility setViewWidth:self.dataView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.divideLine toView:self.dataView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.divideLine constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.divideLine multiplier:0 constant:12.0f],
                             [HHAutoLayoutUtility setViewWidth:self.divideLine multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.avatarView constant:22.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.avatarView constant:18.0f],
                             [HHAutoLayoutUtility setViewHeight:self.avatarView multiplier:0 constant:68.0f],
                             [HHAutoLayoutUtility setViewWidth:self.avatarView multiplier:0 constant:68.0f],
                             
                             ];
    [self.contentView addConstraints:constraints];
}

@end
