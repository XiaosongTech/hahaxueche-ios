//
//  HHBookTrainingViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScheduleType) {
    ScheduleTypeAll, // 所有练车时间
    ScheduleTypeBooked, // 已经预约的练车时间
    ScheduleTypeFinished, // 已经完成的预约时间
    ScheduleTypeCount
};

@interface HHBookTrainingViewController : UIViewController

@end
