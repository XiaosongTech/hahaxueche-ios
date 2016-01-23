//
//  HHStudent.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHStudent : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cellPhone;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *avatarURL;

@end
