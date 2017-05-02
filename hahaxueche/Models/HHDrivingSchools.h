//
//  HHDrivingSchools.h
//  hahaxueche
//
//  Created by Zixiao Wang on 02/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHDrivingSchools : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSArray *schools;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
