//
//  HHActivateCouponView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHActivateCouponViewActionBlock)();

@interface HHActivateCouponView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *freeTrialButton;

@property (nonatomic, strong) HHActivateCouponViewActionBlock actionBlock;

@end
