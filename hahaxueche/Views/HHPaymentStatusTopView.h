//
//  HHPaymentStatusTopView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/20/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPurchasedService.h"
#import "HHMoneyAmountView.h"
#import "HHCoach.h"

@interface HHPaymentStatusTopView : UIView

@property (nonatomic, strong) HHPurchasedService *purchasedService;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *transactionIdLabel;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) HHMoneyAmountView *totalAmountView;
@property (nonatomic, strong) HHMoneyAmountView *payedAmountView;
@property (nonatomic, strong) HHMoneyAmountView *leftAmountView;
@property (nonatomic, strong) HHCoach *coach;


- (instancetype)initWithPurchasedService:(HHPurchasedService *)purchasedService coach:(HHCoach *)coach;
- (void)updatePaidAndUnpaidAmount:(HHPurchasedService *)purchasedService;

@end
