//
//  HHCoachDetailBottomBarView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHGradientButton.h"

typedef void (^HHCoachDetailBottomBarActionBlock)();

@interface HHCoachDetailBottomBarView : UIView

@property (nonatomic, strong) HHGradientButton *tryCoachButton;
@property (nonatomic, strong) HHGradientButton *supportButton;
@property (nonatomic, strong) HHGradientButton *smsButton;
@property (nonatomic, strong) HHGradientButton *callButton;


@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock tryCoachAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock supportAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock smsAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock callAction;


@end
