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
@property (nonatomic, copy) NSNumber *signedContract;
@property (nonatomic, copy) NSNumber *uploadedID;


- (NSString *)getCourseName;
- (NSString *)getPurchasedProductName;

@end
