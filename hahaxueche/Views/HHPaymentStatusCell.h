//
//  HHPaymentStatusCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPaymentStatusCell : UITableViewCell

@property (nonatomic, strong) UILabel *stepNumberLabel;
@property (nonatomic, strong) UILabel *feeNameLabel;
@property (nonatomic, strong) UILabel *feeAmountLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *rightButton;

@end
