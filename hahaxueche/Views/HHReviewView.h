//
//  HHReviewView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/3/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHReview.h"
#import "HHStudent.h"
#import "HHAvatarView.h"
#import "HHRatingView.h"

@interface HHReviewView : UIView

@property (nonatomic, strong) HHReview *review;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) HHRatingView *ratingView;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *line;

- (instancetype)initWithReview:(HHReview *)review;

@end
