//
//  HHReviewer.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/27/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHReviewer : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *reviewerId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *reviewerName;
@property (nonatomic, copy) NSString *userType;


@end
