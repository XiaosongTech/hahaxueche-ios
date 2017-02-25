//
//  HHPaymentMethodsViwe.m
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHPaymentMethodsView.h"
#import "HHPaymentMethodView.h"
#import "Masonry.h"

@implementation HHPaymentMethodsView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedMethod = StudentPaymentMethodAlipay;
        self.views = [NSMutableArray array];
        
        __weak HHPaymentMethodsView *weakSelf = self;
        HHPaymentMethodView *methodView;
        for (int i = 0; i < StudentPaymentMethodCount; i++) {
            switch (i) {
                case StudentPaymentMethodAlipay: {
                    methodView = [[HHPaymentMethodView alloc] initWithTitle:@"支付宝" subTitle:@"推荐拥有支付宝账号的用户使用" icon:[UIImage imageNamed:@"ic_alipay_icon"] selected:YES];
                } break;
                
                case StudentPaymentMethodWechatPay: {
                    methodView = [[HHPaymentMethodView alloc] initWithTitle:@"微信支付" subTitle:@"推荐拥有微信账号的用户使用" icon:[UIImage imageNamed:@"ic_wechatpay_icon"] selected:NO];
                } break;
                
                case StudentPaymentMethodBankCard: {
                    methodView = [[HHPaymentMethodView alloc] initWithTitle:@"银行卡" subTitle:@"一网通支付，支持所有主流借记卡/信用卡" icon:[UIImage imageNamed:@"cmcc_icon"] selected:NO];
                } break;
                
                case StudentPaymentMethodFql: {
                    methodView = [[HHPaymentMethodView alloc] initWithTitle:@"分期乐" subTitle:@"推荐分期用户使用" icon:[UIImage imageNamed:@"fql"] selected:NO];
                } break;
                
                default:
                break;
            }
            methodView.viewSelectedBlock = ^() {
                [weakSelf methodSelected:i];
            };
            [self.views addObject:methodView];
            [self addSubview:methodView];
            [methodView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.top).offset(i * 60.0f);
                make.left.equalTo(self.left);
                make.width.equalTo(self.width);
                make.height.mas_equalTo(60.0f);
            }];
        }
    }
    return self;
}

- (void)methodSelected:(StudentPaymentMethod)method {
    self.selectedMethod = method;
    for (int i = 0; i < self.views.count; i++) {
        HHPaymentMethodView *view = self.views[i];
        if (i == method) {
            view.selected = YES;
        } else {
            view.selected = NO;
        }
    }
    
}

@end
