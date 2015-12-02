//
//  HHCourseProgress.h
//  hahaxueche
//
//  Created by Zixiao Wang on 12/1/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface HHCourseProgress : AVObject<AVSubclassing>

@property (nonatomic, strong) NSNumber *progressNumber;
@property (nonatomic, copy) NSString *progressName;
@property (nonatomic, strong) NSString *courseName;

@end
