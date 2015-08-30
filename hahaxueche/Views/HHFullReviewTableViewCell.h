//
//  HHFullReviewTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHAvatarView.h"
#import "HHReview.h"

@interface HHFullReviewTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setupViews:(HHReview *)review;

@end
