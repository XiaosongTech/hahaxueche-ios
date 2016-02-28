//
//  HHReview.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHReviewer.h"

@interface HHReview : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) HHReviewer *reviewer;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *reviewId;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSDate *updatedAt;


@end
