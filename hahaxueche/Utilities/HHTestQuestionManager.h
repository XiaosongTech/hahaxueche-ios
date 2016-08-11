//
//  HHTestQuestionManager.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHQuestion.h"

typedef NS_ENUM(NSInteger, TestMode) {
    TestModeOrder, // 顺序练题
    TestModeRandom, // 随机练题
    TestModeSimu, //全真模拟
};

typedef NS_ENUM(NSInteger, CourseMode) {
    CourseMode1, // 科目一
    CourseMode4, // 科目四
};

@interface HHTestQuestionManager : NSObject

@property (nonatomic, strong) NSMutableArray *allCourseMode1Questions;
@property (nonatomic, strong) NSMutableArray *allCourseMode4Questions;

+ (HHTestQuestionManager *)sharedManager;
- (NSMutableArray *)generateQuestionsWithMode:(TestMode)testMode courseMode:(CourseMode)courseMode;

@end
