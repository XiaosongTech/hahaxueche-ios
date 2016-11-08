//
//  HHAdvisor.h
//  hahaxueche
//
//  Created by Zixiao Wang on 20/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHAdvisor : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *avaURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *shortIntro;
@property (nonatomic, copy) NSString *longIntro;
@property (nonatomic, copy) NSString *advisorId;

@end
