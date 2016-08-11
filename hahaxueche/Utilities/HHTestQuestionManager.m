//
//  HHTestQuestionManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTestQuestionManager.h"

@implementation HHTestQuestionManager

+ (HHTestQuestionManager *)sharedManager {
    static HHTestQuestionManager *manager = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^() {
        manager = [[HHTestQuestionManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allCourseMode1Questions = [self getAllQuestionsForCourseMode:CourseMode1];
        self.allCourseMode4Questions = [self getAllQuestionsForCourseMode:CourseMode4];
    }
    return self;
}


- (NSMutableArray *)getAllQuestionsForCourseMode:(CourseMode)courseMode {
    NSString *fileName;
    switch (courseMode) {
        case CourseMode1: {
            fileName = @"course1";
        } break;
            
        case CourseMode4: {
            fileName = @"course4";
        } break;
            
        default: {
            fileName = @"course1";
        } break;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions error:nil];
    NSArray *questions = dic[@"result"];
    NSMutableArray *questionObjects = [NSMutableArray array];
    for (NSDictionary *dictionary in questions) {
        HHQuestion *question = [MTLJSONAdapter modelOfClass:[HHQuestion class] fromJSONDictionary:dictionary error:nil];
        [questionObjects addObject:question];
    }
    return questionObjects;
}

- (NSMutableArray *)generateQuestionsWithMode:(TestMode)testMode courseMode:(CourseMode)courseMode {
    NSMutableArray *questions;
    NSMutableArray *finalquestions;
    
    switch (courseMode) {
        case CourseMode1: {
            questions = [NSMutableArray arrayWithArray:self.allCourseMode1Questions];
        } break;
            
        case CourseMode4: {
            questions = [NSMutableArray arrayWithArray:self.allCourseMode4Questions];
        } break;
            
        default: {
            questions = [NSMutableArray arrayWithArray:self.allCourseMode1Questions];
        } break;
    }
    
    switch (testMode) {
        case TestModeOrder: {
            finalquestions = questions;
        } break;
            
        case TestModeRandom: {
            finalquestions = questions;
            for (int i = 0; i < [questions count]; i++) {
                int randInt = (arc4random() % ([questions count] - i)) + i;
                [finalquestions exchangeObjectAtIndex:i withObjectAtIndex:randInt];
            }
        } break;
            
        case TestModeSimu: {
            finalquestions = [NSMutableArray array];
            for (NSNumber *index in [self getSimuQuestionsIndex:questions]) {
                [finalquestions addObject:questions[[index integerValue]]];
            }
        } break;
            
        default: {
            finalquestions = questions;
        } break;
    }
    
    return finalquestions;

}

- (NSMutableArray *)getSimuQuestionsIndex:(NSMutableArray *)questions {
    NSMutableArray *numbers = [NSMutableArray array];
    while ([numbers count] < 100) {
        NSNumber *number = [self getRandomNumberBetween:0 to:(int)questions.count-1];
        if (![numbers containsObject:number]) {
            [numbers addObject:number];
        }
    }
    return numbers;
}


- (NSNumber *)getRandomNumberBetween:(int)from to:(int)to {
    return @((int)from + arc4random() % (to-from+1));
}



@end
