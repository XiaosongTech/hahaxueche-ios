//
//  HHUser.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/8/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHStudent.h"

@interface HHUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *cellPhone;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) HHStudent *student;

@end
