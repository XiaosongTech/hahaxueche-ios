//
//  HHTestQuestionManager.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//


#import "HHTestQuestionManager.h"

static NSString *const kCourse1OrderIndex = @"kCourse1OrderIndex";
static NSString *const kCourse4OrderIndex = @"kCourse4OrderIndex";

static NSString *const kCourse1FavoratedKey = @"kCourse1FavoratedKey";
static NSString *const kCourse4FavoratedKey = @"kCourse4FavoratedKey";

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
            fileName = @"one";
        } break;
            
        case CourseMode4: {
            fileName = @"four";
        } break;
            
        default: {
            fileName = @"one";
        } break;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions error:nil];
        NSArray *questions = (NSArray *)dic;
        NSMutableArray *questionObjects = [NSMutableArray array];
        for (NSDictionary *dictionary in questions) {
            HHQuestion *question = [MTLJSONAdapter modelOfClass:[HHQuestion class] fromJSONDictionary:dictionary error:nil];
            [questionObjects addObject:question];
        }
        return questionObjects;
    } else {
        return nil;
    }
   
}

- (NSMutableArray *)generateQuestionsWithMode:(TestMode)testMode courseMode:(CourseMode)courseMode {
    NSMutableArray *questions;
    NSMutableArray *finalquestions;
    
    switch (courseMode) {
        case CourseMode1: {
            questions = [NSMutableArray arrayWithArray:[self getAllQuestionsForCourseMode:CourseMode1]];
        } break;
            
        case CourseMode4: {
            questions = [NSMutableArray arrayWithArray:[self getAllQuestionsForCourseMode:CourseMode4]];
        } break;
            
        default: {
            questions = [NSMutableArray arrayWithArray:[self getAllQuestionsForCourseMode:CourseMode1]];
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
            for (NSNumber *index in [self getSimuQuestionsIndex:questions courseMode:courseMode]) {
                [finalquestions addObject:questions[[index integerValue]]];
            }
        } break;
            
        case TestModeFavQuestions: {
            finalquestions = [self getFavQuestionsWithCourseMode:courseMode];
        } break;
            
        default: {
            finalquestions = questions;
        } break;
    }
    
    return finalquestions;

}

- (NSMutableArray *)getSimuQuestionsIndex:(NSMutableArray *)questions courseMode:(CourseMode)courseMode{
    NSMutableArray *numbers = [NSMutableArray array];
    NSInteger count = kSimuCourse1QuestionCount;
    if (courseMode == CourseMode4) {
        count = kSimuCourse4QuestionCount;
    }
    while ([numbers count] < count) {
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

- (void)saveOrderTestIndexWithCourseMode:(CourseMode)courseMode index:(NSInteger)index {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (courseMode) {
        case CourseMode1: {
            [defaults setObject:@(index) forKey:kCourse1OrderIndex];
        } break;
            
        case CourseMode4: {
            
            [defaults setObject:@(index) forKey:kCourse4OrderIndex];
        } break;
            
        default:
            break;
    }
    
}

- (NSInteger)getOrderTestIndexWithCourseMode:(CourseMode)courseMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *index;
    switch (courseMode) {
        case CourseMode1: {
            index = [defaults objectForKey:kCourse1OrderIndex];
            if (![index isKindOfClass:[NSNumber class]]) {
                index = @(0);
            } else {
                if ([index integerValue] >= self.allCourseMode1Questions.count) {
                    index = @(0);
                }
            }
            
        } break;
            
        case CourseMode4: {
            index = [defaults objectForKey:kCourse4OrderIndex];
            if (![index isKindOfClass:[NSNumber class]]) {
                index = @(0);
            } else {
                if ([index integerValue] >= self.allCourseMode4Questions.count) {
                    index = @(0);
                }
            }
        } break;
            
        default: {
            index = [defaults objectForKey:kCourse1OrderIndex];
            if ([index integerValue] >= self.allCourseMode1Questions.count) {
                index = @(0);
            }

        } break;
    }
    return [index integerValue];

}

- (BOOL)favorateQuestion:(HHQuestion *)question courseMode:(CourseMode)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = kCourse1FavoratedKey;
    if (mode == CourseMode4) {
        key = kCourse4FavoratedKey;
    }
    NSMutableArray *array =  [NSMutableArray arrayWithArray:[defaults arrayForKey:key]];
    
    if ([array containsObject:question.questionId]) {
        [array removeObject:question.questionId];
        [defaults setObject:array forKey:key];
        return NO;
    } else {
        [array addObject:question.questionId];
        [defaults setObject:array forKey:key];
        return YES;
    }
    
}

- (BOOL)isFavoratedQuestion:(HHQuestion *)question courseMode:(CourseMode)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = kCourse1FavoratedKey;
    if (mode == CourseMode4) {
        key = kCourse4FavoratedKey;
    }

    NSMutableArray *array =  [NSMutableArray arrayWithArray:[defaults arrayForKey:key]];
    
    return [array containsObject:question.questionId];

}

- (NSMutableArray *)getFavQuestionsWithCourseMode:(CourseMode)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allQuestions = self.allCourseMode1Questions;
    NSString *key = kCourse1FavoratedKey;
    if (mode == CourseMode4) {
        key = kCourse4FavoratedKey;
        allQuestions = self.allCourseMode4Questions;
    }
    
    NSMutableArray *questionIdArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:key]];

    NSMutableArray *questions = [NSMutableArray array];
    for (NSNumber *questionId in questionIdArray) {
         NSArray *question = [allQuestions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"questionId == %@", questionId]];
        [questions addObjectsFromArray:question];
    }
    return questions;
}



@end
