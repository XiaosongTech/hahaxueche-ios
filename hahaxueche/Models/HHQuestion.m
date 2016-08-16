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
             @"questionId": @"id",
             @"questionDes": @"question",
             @"answer": @"answer",
             @"item1": @"item1",
             @"item2": @"item2",
             @"item3": @"item3",
             @"item4": @"item4",
             @"explains": @"explains",
             @"imgURL":@"url",
             
             };
}

- (BOOL)isAnswerCorrect:(NSMutableArray *)answers {
    BOOL isCorrect = NO;
    if ([self.answer isEqualToString:@"1"]) {
        if ([answers count] == 1 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
    } else if ([self.answer isEqualToString:@"2"]) {
        if ([answers count] == 1 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(2)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"3"]) {
        if ([answers count] == 1 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(3)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"4"]) {
        if ([answers count] == 1 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"7"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(2)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"8"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(3)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"9"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"10"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(2), @(3)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"11"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(2), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"12"]) {
        if ([answers count] == 2 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(3), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"13"]) {
        if ([answers count] == 3 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(2), @(3)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"14"]) {
        if ([answers count] == 3 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(2), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"15"]) {
        if ([answers count] == 3 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(3), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"16"]) {
        if ([answers count] == 3 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(2), @(3), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    } else if ([self.answer isEqualToString:@"17"]) {
        if ([answers count] == 4 && [self contaisAllCorrectAnswers:answers standardAnswers:@[@(1), @(2), @(3), @(4)]]) {
            isCorrect = YES;
        } else {
            isCorrect = NO;
        }
        
    }
    return isCorrect;
}

- (BOOL)contaisAllCorrectAnswers:(NSMutableArray *)answers standardAnswers:(NSArray *)standardAnswers {
    for (NSNumber *number in answers) {
        if (![standardAnswers containsObject:number]) {
            return NO;
        }
        
    }
    return YES;
}


- (NSString *)getQuestionTypeString {
    if ([self.answer integerValue] > 4) {
        return @"多选题";
    } else {
        if (!self.item3 || [self.item3 isEqualToString:@""]) {
            return @"判断题";
        } else {
            return @"单选题";
        }
    }

}


- (BOOL)hasImage {
    if (self.imgURL && ![self.imgURL isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)standardAnswers {
    if ([self.answer isEqualToString:@"1"]) {
        return @[@(1)];
    } else if ([self.answer isEqualToString:@"2"]) {
        return @[@(2)];
    } else if ([self.answer isEqualToString:@"3"]) {
        return @[@(3)];
    } else if ([self.answer isEqualToString:@"4"]) {
        return @[@(4)];
    } else if ([self.answer isEqualToString:@"7"]) {
        return @[@(1), @(2)];
    } else if ([self.answer isEqualToString:@"8"]) {
        return @[@(1), @(3)];
    } else if ([self.answer isEqualToString:@"9"]) {
        return @[@(1), @(4)];
    } else if ([self.answer isEqualToString:@"10"]) {
        return @[@(2), @(3)];
    } else if ([self.answer isEqualToString:@"11"]) {
        return @[@(2), @(4)];
    } else if ([self.answer isEqualToString:@"12"]) {
        return @[@(3), @(4)];
    } else if ([self.answer isEqualToString:@"13"]) {
        return @[@(1), @(2), @(3)];
    } else if ([self.answer isEqualToString:@"14"]) {
        return @[@(1), @(2), @(4)];
        
    } else if ([self.answer isEqualToString:@"15"]) {
        return @[@(1), @(3), @(4)];
        
    } else if ([self.answer isEqualToString:@"16"]) {
        return @[@(2), @(3), @(4)];
        
    } else if ([self.answer isEqualToString:@"17"]) {
        return @[@(1), @(2), @(3), @(4)];
    }
    return nil;
}

@end
