//
//  HHBankCard.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHBankCard : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *cardHolderName;

@end
