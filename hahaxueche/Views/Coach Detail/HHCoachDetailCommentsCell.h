//
//  HHCoachDetailCommentsCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHCoach.h"

@interface HHCoachDetailCommentsCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *botLabel;
@property (nonatomic, strong) HHStarRatingView *aveRatingView;
@property (nonatomic, strong) UILabel *aveRatingLabel;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *topBackgroudView;
@property (nonatomic, strong) UIView *botBackgroudView;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) UIButton *seeMoreButton;

- (void)setupCellWithCoach:(HHCoach *)coach reviews:(NSArray *)reviews;

@end
