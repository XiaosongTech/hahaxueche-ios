//
//  HHReview.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+Subclass.h"

@interface HHReview : AVObject <AVSubclassing>

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, copy) NSString *comment;

@end
