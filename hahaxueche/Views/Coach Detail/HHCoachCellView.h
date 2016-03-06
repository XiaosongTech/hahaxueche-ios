//
//  HHCoachCellView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHCoachCellView : UIView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) HHCoach *coach;

- (instancetype)initWithCoach:(HHCoach *)coach;

@end
