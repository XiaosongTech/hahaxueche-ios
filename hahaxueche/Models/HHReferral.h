//
//  HHReferral.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/10/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHReferral : AVObject <AVSubclassing>

@property (nonatomic, strong) NSString *referCode;
@property (nonatomic, strong) NSString *studentId;

@end
