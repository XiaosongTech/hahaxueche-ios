//
//  HHCoachCommentView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHCoachComment.h"

@interface HHCoachCommentView : UIView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIView *botLine;

- (void)setupViewWithComment:(HHCoachComment *)comment;



@end
