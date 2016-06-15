//
//  HHWithdraws.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHWithdraw.h"

@interface HHWithdraws : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *withdraws;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
