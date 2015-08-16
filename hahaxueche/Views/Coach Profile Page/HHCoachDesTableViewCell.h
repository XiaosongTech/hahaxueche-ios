//
//  HHCoachDesTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAvatarView.h"
#import "HHCoach.h"

typedef void (^CoachTappedBlock)();

@interface HHCoachDesTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) CoachTappedBlock block;

- (void)setupViewWithURL:(NSString *)url name:(NSString *)name des:(NSMutableAttributedString *)des;

@end
