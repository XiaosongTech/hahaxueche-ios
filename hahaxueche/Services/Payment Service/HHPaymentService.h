//
//  HHPaymentService.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/22/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pingpp/Pingpp.h>

typedef NS_ENUM(NSInteger, StudentPaymentMethod) {
    StudentPaymentMethodAlipay, // 支付宝
    StudentPaymentMethodWechatPay, // 微信支付
    StudentPaymentMethodBankCard, // 银行卡
    StudentPaymentMethodFql, //分期乐
    StudentPaymentMethodCount, //分期乐
};

typedef NS_ENUM(NSInteger, CoachProductType) {
    CoachProductTypeStandard, // 普通服务
    CoachProductTypeVIP, //VIP
    CoachProductTypeC2Standard, //c2普通服务
    CoachProductTypeC2VIP, //C2 VIP
    CoachProductTypeC1Wuyou, //c1无忧
    CoachProductTypeC2Wuyou, //C2 无忧
};

typedef void (^HHPaymentResultCompletion)(BOOL succeed);

@interface HHPaymentService : NSObject

+ (instancetype)sharedInstance;


- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod productType:(CoachProductType)productType voucherId:(NSString *)voucherId needInsurance:(BOOL)needInsurance inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

- (void)purchaseInsuranceWithpaymentMethod:(StudentPaymentMethod)paymentMethod inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

//0=提“钱”抢红包488, 1=提“钱”抢红包388, 2=情人节88换388, 3=预付100得300	
- (void)prepayWithType:(NSInteger)type paymentMethod:(StudentPaymentMethod)paymentMethod inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

@end
