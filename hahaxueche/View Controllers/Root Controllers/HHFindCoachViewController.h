//
//  HHFindCoachViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

typedef void (^HHRefreshCoachCompletionBlock)();
typedef void (^HHUserLocationCompletionBlock)();

typedef NS_ENUM(NSInteger, ListType) {
    ListTypeDrivingSchool,
    ListTypeCoach,
    ListTypeCount,
};

@interface HHFindCoachViewController : UIViewController

@property (nonatomic, strong) SwipeView *swipeView;

@end
