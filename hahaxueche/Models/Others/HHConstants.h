//
//  HHConstants.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHConstants : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *cities;
@property (nonatomic, copy) NSArray *fields;
@property (nonatomic, copy) NSArray *loginBanners;
@property (nonatomic, copy) NSArray *homePageBanners;
@property (nonatomic, copy) NSArray *notifications;
@property (nonatomic, copy) NSArray *banks;

@end
