//
//  HHCoachPriceTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCoach.h"
#import "HHLicenseTypeView.h"
#import "HHPaymentService.h"

typedef void (^HHCoachPriceAction)(NSInteger type);
typedef void (^HHCoachPurchaseAction)(CoachProductType type);


@interface HHCoachPriceTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *licenseView;
@property (nonatomic, strong) HHLicenseTypeView *c1View;
@property (nonatomic, strong) HHLicenseTypeView *c2View;
@property (nonatomic, strong) UIView *licenseMidLine;

@property (nonatomic, strong) UIView *c1ContainerView;
@property (nonatomic, strong) UIView *c2ContainerView;

@property (nonatomic) NSInteger selectedType;

@property (nonatomic, strong) HHCoachPriceAction questionMarkBlock;
@property (nonatomic, strong) HHCoachPriceAction selectedBlock;
@property (nonatomic, strong) HHCoachPurchaseAction purchaseBlock;
@property (nonatomic, strong) HHCoachPurchaseAction priceDetailBlock;

- (void)setupCellWithCoach:(HHCoach *)coach selectedType:(NSInteger)type;

@end
