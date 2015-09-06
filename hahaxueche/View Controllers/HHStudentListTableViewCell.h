//
//  HHStudentListTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/6/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAvatarView.h"
#import "HHStudent.h"

@interface HHStudentListTableViewCell : UITableViewCell

@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *containerView;

- (void)setupViewsWithStudent:(HHStudent *)student priceString:(NSString *)priceString;

@end
