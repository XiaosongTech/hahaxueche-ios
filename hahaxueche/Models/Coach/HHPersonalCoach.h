//
//  HHPersonalCoach.h
//  hahaxueche
//
//  Created by Zixiao Wang on 17/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHPersonalCoach : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSNumber *experienceYear;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSNumber *liked;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *intro;


@end
