//
//  HHUser.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/17/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHUser : AVUser <AVSubclassing>

@property (nonatomic, strong) NSString *type;

@end
