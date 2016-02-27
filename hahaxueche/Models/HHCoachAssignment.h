//
//  HHCoachAssignment.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHCoachAssignment : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, copy) NSNumber *serviceType;

@end
