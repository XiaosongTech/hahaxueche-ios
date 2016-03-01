//
//  HHReviews.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHReviews : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *reviews;
@property (nonatomic, copy) NSString *nextPage;
@property (nonatomic, copy) NSString *prePage;

@end
