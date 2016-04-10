//
//  HHCoachSchedules.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoachSchedules : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *schedules;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
