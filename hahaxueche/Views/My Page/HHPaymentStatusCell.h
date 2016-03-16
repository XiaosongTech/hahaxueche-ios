//
//  HHPaymentStatusCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPaymentStage.h"


typedef void (^HHPaymentStatusRightButtonActionBlock)();

@interface HHPaymentStatusCell : UITableViewCell

@property (nonatomic, strong) UILabel *stepNumberLabel;
@property (nonatomic, strong) UILabel *feeNameLabel;
@property (nonatomic, strong) UILabel *feeAmountLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) HHPaymentStatusRightButtonActionBlock rightButtonBlock;

- (void)setupCellWithPaymentStage:(HHPaymentStage *)paymentStage currentStatge:(NSNumber *)currentStage;

@end
