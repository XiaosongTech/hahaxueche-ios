//
//  HHCoachPriceInfoView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 09/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPaymentService.h"
#import "HHCoach.h"
#import "HHCoachPriceTableViewCell.h"


@interface HHCoachPriceInfoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *callSchoolButton;
@property (nonatomic, strong) UIButton *notifPriceButton;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic) CoachProductType type;

@property (nonatomic, strong) HHCoachGenericAction callBlock;
@property (nonatomic, strong) HHCoachGenericAction notifPriceBlock;

- (instancetype)initWithClassType:(CoachProductType)type coach:(HHCoach *)coach showLine:(BOOL)showLine;
- (instancetype)initWithClassType:(CoachProductType)type coach:(HHCoach *)coach;

@end
