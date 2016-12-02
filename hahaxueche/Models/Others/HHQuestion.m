//
//  HHQuestion.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHQuestion.h"
#import "HHTestQuestionManager.h"

@implementation HHQuestion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"questionId": @"questionid",
             @"questionDes": @"question",
             @"correctAnswers": @"answer_arr",
             @"explains": @"explain",
             @"mediaType":@"mediatype",
             @"mediaURL":@"mediacontent",
             @"optionType":@"optiontype",
             @"options":@"answers",
             };
}

- (BOOL)isAnswerCorrect:(NSMutableArray *)answers {
    if (answers.count !=  self.correctAnswers.count) {
        return NO;
    }
    for (NSString *number in answers) {
        if (![self.correctAnswers containsObject:number]) {
            return NO;
        }
        
    }
    return YES;
}



- (NSString *)getQuestionTypeString {
    if ([self.optionType isEqualToString:@"2"]) {
        return @"多选题";
    } else {
        if (self.options.count == 2) {
            return @"判断题";
        } else {
            return @"单选题";
        }
    }

}



@end
