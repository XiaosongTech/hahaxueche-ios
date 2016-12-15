//
//  HHCoachBadgeView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 07/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"

@interface HHCoachBadgeView : UIView

- (instancetype)initWithCoach:(HHCoach *)coach;

@property (nonatomic, strong) UIView *preView;

@end
