//
//  HHTransfer.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/30/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTransfer.h"

@implementation HHTransfer

@dynamic coachId;
@dynamic studentId;
@dynamic transactionId;
@dynamic stage;
@dynamic amount;
@dynamic payeeAccount;
@dynamic payeeAccountType;
@dynamic transferStatus;

+ (NSString *)parseClassName {
    return @"Transfer";
}


@end
