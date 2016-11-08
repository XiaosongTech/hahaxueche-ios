//
//  HHCoachDetailBottomBarView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCoachDetailBottomBarActionBlock)();

@interface HHCoachDetailBottomBarView : UIView

@property (nonatomic, strong) UIButton *tryCoachButton;
@property (nonatomic, strong) UIButton *purchaseCoachButton;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock tryCoachAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock purchaseCoachAction;


@end
