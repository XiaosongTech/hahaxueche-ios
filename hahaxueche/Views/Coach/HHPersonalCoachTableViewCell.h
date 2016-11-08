//
//  HHPersonalCoachTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHPriceView.h"
#import "HHPersonalCoach.h"

@interface HHPersonalCoachTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *trainingYearLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) HHPriceView *priceView;

- (void)setupCellWithCoach:(HHPersonalCoach *)coach;

@end
