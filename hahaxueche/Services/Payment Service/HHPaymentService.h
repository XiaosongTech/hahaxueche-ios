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
    StudentPaymentMethodBankCard, // 银行卡
    StudentPaymentMethodAlipay, // 支付宝
    StudentPaymentMethodFql, //分期乐
};

typedef NS_ENUM(NSInteger, CoachProductType) {
    CoachProductTypeStandard, // 普通服务
    CoachProductTypeVIP, //VIP
    CoachProductTypeC2Standard, //c2普通服务
    CoachProductTypeC2VIP, //C2 VIP
   
};

typedef void (^HHPaymentResultCompletion)(BOOL succeed);

@interface HHPaymentService : NSObject

+ (instancetype)sharedInstance;


- (void)payWithCoachId:(NSString *)coachId studentId:(NSString *)studentId paymentMethod:(StudentPaymentMethod)paymentMethod productType:(CoachProductType)productType voucherId:(NSString *)voucherId inController:(UIViewController *)viewController completion:(HHPaymentResultCompletion)completion;

@end
