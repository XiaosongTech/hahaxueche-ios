//
//  HHTransfer.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/30/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHTransfer : AVObject <AVSubclassing>

@property(nonatomic, copy) NSString *coachId;
@property(nonatomic, copy) NSString *studentId;
@property(nonatomic, copy) NSString *transactionId;
@property(nonatomic, copy) NSNumber *stage;
@property(nonatomic, copy) NSNumber *amount;
@property(nonatomic, copy) NSString *payeeAccount;
@property(nonatomic, copy) NSString *payeeAccountType;
@property(nonatomic, copy) NSString *transferStatus;


@end
