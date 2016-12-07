//
//  HHCoachDetailDescriptionCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHPersonalCoach.h"
#import "HHCoachTagView.h"
#import "HHCoachBadgeView.h"

typedef void (^HHLikeCoachBlock)(UIButton *likeButton, UILabel *likeCountLabel);
typedef void (^HHFollowCoachBlock)();

@interface HHCoachDetailDescriptionCell : UITableViewCell

@property (nonatomic, strong) UIView *avatarBackgroungView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) HHCoachTagView *jiaxiaoView;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) HHCoachBadgeView *badgeView;

@property (nonatomic, strong) HHLikeCoachBlock likeBlock;
@property (nonatomic, strong) HHFollowCoachBlock followBlock;

- (void)setupCellWithCoach:(HHCoach *)coach followed:(BOOL)followed;
- (void)setupCellWithCoach:(HHPersonalCoach *)coach;


@end
