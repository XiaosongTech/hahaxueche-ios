//
//  HHBankCard.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHBankCard.h"

@implementation HHBankCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bankCode": @"open_bank_code",
             @"bankName": @"bank_name",
             @"cardNumber": @"card_number",
             @"cardHolderName": @"name"
             };
}




@end
