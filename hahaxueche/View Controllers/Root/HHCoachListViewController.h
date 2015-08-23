//
//  HHCoachListViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHGenericCompletion)();

typedef enum : NSUInteger {
    SortOptionSmartSort,
    SortOptionLowestPrice,
    SortOptionBestRating,
    SortOptionMostPopular,
} SortOption;

typedef enum : NSUInteger {
    CourseTwo,
    CourseThree,
    CourseAllInOne
} CourseOption;

@interface HHCoachListViewController : UIViewController

@end
