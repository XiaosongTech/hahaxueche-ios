//
//  HHConstantsStore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHConstants.h"
#import "HHField.h"
#import "HHCity.h"
#import "HHBank.h"

typedef void (^HHConstantsCompletion)(HHConstants *constants);

@interface HHConstantsStore : NSObject

@property (nonatomic, strong) HHConstants *constants;

+ (instancetype)sharedInstance;
- (void)getConstantsWithCompletion:(HHConstantsCompletion)completion;

- (NSArray *)getAllFieldsForCity:(NSNumber *)cityId;
- (NSArray *)getSupporteCities;
- (HHField *)getFieldWithId:(NSString *)fieldId;
- (HHCity *)getAuthedUserCity;
- (HHCity *)getCityWithId:(NSNumber *)cityId;
- (NSArray *)getLoginBanners;
- (NSArray *)getHomePageBanners;
- (NSArray *)getNotifications;
- (NSNumber *)getCityReferrerBonus;
- (NSNumber *)getCityRefereeBonus;

- (NSArray *)getAllBanks;
- (NSArray *)getPopularBanks;
- (HHBank *)getCardBankWithCode:(NSString *)bankCode;

//type: 0, 1, 2
- (NSNumber *)getInsuranceWithType:(NSInteger)type;


@end
