//
//  HHIdentityCard.h
//  hahaxueche
//
//  Created by Zixiao Wang on 29/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHIdentityCard : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *address;

@end
