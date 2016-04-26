//
//  HHPaymentMethodCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentMethodCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHPaymentMethodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:21.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    
    self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(20.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(-10.0f);
        make.left.equalTo(self.iconView.right).offset(15.0f);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(15.0f);
        make.left.equalTo(self.iconView.right).offset(15.0f);
    }];
}

-(void)setupCellWithType:(PaymentMethod)type {
    switch (type) {
        case PaymentMethodAlipay: {
            self.iconView.image = [UIImage imageNamed:@"ic_alipay_icon"];
            self.titleLabel.text = @"支付宝";
            self.subTitleLabel.textColor = [UIColor HHLightTextGray];
            self.subTitleLabel.text = @"推荐有支付宝的用户使用";
            self.titleLabel.textColor = [UIColor HHTextDarkGray];
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_cashout_chack_btn"]];
            [self.accessoryView setFrame:CGRectMake(0, 0, 24, 24)];
        } break;
            
        case PaymentMethodWeChatPay: {
            self.iconView.image = [UIImage imageNamed:@"ic_wechatpay_icon"];
            self.titleLabel.text = @"微信钱包(暂不支持)";
            self.subTitleLabel.textColor = [UIColor HHLightestTextGray];
            self.subTitleLabel.text = @"推荐安装微信5.0级以上版本使用";
            self.titleLabel.textColor = [UIColor HHLightestTextGray];
            
        } break;
            
        case PaymentMethodBankCard: {
            self.iconView.image = [UIImage imageNamed:@"ic_cardpay_icon"];
            self.titleLabel.text = @"银行卡(暂不支持)";
            self.subTitleLabel.textColor = [UIColor HHLightestTextGray];
            self.subTitleLabel.text = @"支持储蓄银行卡";
            self.titleLabel.textColor = [UIColor HHLightestTextGray];
        } break;
            
        default:
            break;
    }
}

@end
