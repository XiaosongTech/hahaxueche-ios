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

@property (nonatomic, strong) UIImageView *followIconView;
@property (nonatomic, strong) UIImageView *shareIconView;
@property (nonatomic, strong) UIButton *tryCoachButton;
@property (nonatomic, strong) UIButton *purchaseCoachButton;

@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *followContainerView;
@property (nonatomic, strong) UIView *shareContainerView;

@property (nonatomic) BOOL followed;

@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock shareAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock followAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock unFollowAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock tryCoachAction;
@property (nonatomic, strong) HHCoachDetailBottomBarActionBlock purchaseCoachAction;

- (instancetype)initWithFrame:(CGRect)frame followed:(BOOL)followed;

@end
