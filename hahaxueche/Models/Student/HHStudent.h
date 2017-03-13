//
//  HHStudent.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHPurchasedService.h"
#import "HHCoupon.h"
#import "HHBankCard.h"
#import "HHAdvisor.h"
#import "HHIdentityCard.h"
#import "HHInsuranceOrder.h"

@interface HHStudent : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cellPhone;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSArray *purchasedServiceArray;
@property (nonatomic, copy) NSString *currentCoachId;
@property (nonatomic, copy) NSNumber *currentCourse;
@property (nonatomic, copy) NSNumber *bonusBalance;
@property (nonatomic, copy) NSNumber *byReferal;
@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, strong) HHBankCard *bankCard;

@property (nonatomic, strong) HHAdvisor *myAdvisor;
@property (nonatomic, copy) NSArray *vouchers;
@property (nonatomic, copy) NSString *agreementURL;
@property (nonatomic, strong) HHIdentityCard *idCard;
@property (nonatomic, copy) NSString *userIdentityId;
//区分代理和用户--用于推荐有奖
@property (nonatomic, copy) NSNumber *isAgent;

@property (nonatomic, strong) HHInsuranceOrder *insuranceOrder;
@property (nonatomic, strong) NSNumber *prepayAmount;


- (NSString *)getCourseName;
- (NSString *)getPurchasedProductName;
- (BOOL)isLoggedIn;
- (BOOL)isPurchased;

@end
