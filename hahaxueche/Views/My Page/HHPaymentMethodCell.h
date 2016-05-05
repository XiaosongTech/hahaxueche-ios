//
//  HHPaymentMethodCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaymentMethod) {
    PaymentMethodAlipay, // 支付宝
    PaymentMethodWeChatPay, // 微信支付
    PaymentMethodBankCard, // 银行卡
    PaymentMethodCount
};

@interface HHPaymentMethodCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

- (void)setupCellWithType:(PaymentMethod)type;

@end
