//
//  HHStudent.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHStudent.h"
#import "HHPaymentService.h"
#import "HHVoucher.h"

@implementation HHStudent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"studentId": @"id",
             @"userId": @"user_id",
             @"cellPhone": @"cell_phone",
             @"name": @"name",
             @"cityId": @"city_id",
             @"avatarURL": @"avatar",
             @"purchasedServiceArray":@"purchased_services",
             @"currentCoachId":@"current_coach_id",
             @"currentCourse":@"current_course",
             @"bonusBalance":@"bonus_balance",
             @"byReferal":@"by_referal",
             @"coupons":@"coupons",
             @"bankCard":@"bank_card",
             @"vouchers":@"vouchers",
             @"agreementURL":@"agreement_url",
             @"idCard":@"identity_card",
             };
}

+ (NSValueTransformer *)couponsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHCoupon class]];
}

+ (NSValueTransformer *)purchasedServiceArrayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHPurchasedService class]];
}

+ (NSValueTransformer *)bankCardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHBankCard class]];
}

+ (NSValueTransformer *)idCardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HHIdentityCard class]];
}

- (NSString *)getCourseName {
    switch ([self.currentCourse integerValue]) {
        case 0: {
            return @"科目一";
        }
        case 1: {
            return @"科目二";
        }
        case 2: {
            return @"科目三";
        }
        case 3: {
            return @"科目四";
        }
        default: {
            return @"已拿证";
        }
            
    }
}


- (NSString *)getPurchasedProductName {
    HHPurchasedService *ps = [self.purchasedServiceArray firstObject];
    switch ([ps.productType integerValue]) {
        case CoachProductTypeStandard: {
            return @"C1手动挡-超值班";
        }
        case CoachProductTypeVIP: {
            return @"C1手动挡-VIP班";
        }
            
        case CoachProductTypeC2Standard: {
            return @"C2自动挡-超值班";
        }
            
        case CoachProductTypeC2VIP: {
            return @"C2自动挡-VIP班";
        }
        default: return @"C1手动挡-超值班";
    }
}

+ (NSValueTransformer *)vouchersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HHVoucher class]];
}

- (BOOL)isLoggedIn {
    return (self.studentId && ![self.studentId isEqualToString:@""]);
}

- (BOOL)isPurchased {
    return [self.purchasedServiceArray count];
}

@end
