//
//  HHReferral.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHReferral.h"

@implementation HHReferral

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"referralId": @"id",
             @"refereeBonusAmount": @"referee_bonus_amount",
             @"refererBonusAmount":@"referer_bonus_amount",
             @"refereeName": @"referee_status.name",
             @"refereeAvatar":@"referee_status.avatar_url",
             @"status":@"referee_status.status",
             };
}

- (NSString *)getStatusString {
    if ([self.status integerValue] == 0) {
        return @"已经报名教练并付款";
    } else {
        return @"已注册, 还没有报名教练";
    }
}

@end
