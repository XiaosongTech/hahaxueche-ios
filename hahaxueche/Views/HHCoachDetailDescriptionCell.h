//
//  HHCoachDetailDescriptionCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHCoachDetailDescriptionCell : UITableViewCell

@property (nonatomic, strong) UIView *avatarBackgroungView;
@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

- (void)setupCellWithCoach:(HHCoach *)coach;


@end
