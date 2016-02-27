//
//  HHReview.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/24/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "HHStudent.h"

@interface HHReview : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) HHStudent *reviewer;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *reviewId;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSDate *date;


@end
