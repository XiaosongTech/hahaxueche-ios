//
//  HHReviewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHReview.h"

@interface HHReviewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIView *botLine;

- (void)setupViewWithReview:(HHReview *)review;

@end
