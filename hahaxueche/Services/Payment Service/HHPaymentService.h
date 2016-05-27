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
    StudentPaymentMethodFql, //分期乐
    StudentPaymentMethodWeChatPay, // 微信支付
    StudentPaymentMethodBankCard, // 银行卡
    StudentPaymentMethodCount
};

typedef void (^HHPaymentResultCompletion)(BOOL succeed);

@interface HHPaymentService : NSObject

+ (instancetype)sharedInstance;


- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

@end
