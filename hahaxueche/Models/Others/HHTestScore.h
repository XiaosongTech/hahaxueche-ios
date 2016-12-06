//
//  HHTestScore.h
//  hahaxueche
//
//  Created by Zixiao Wang on 05/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHTestScore : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *course;
@property (nonatomic, strong) NSDate *createdAt;

@end
