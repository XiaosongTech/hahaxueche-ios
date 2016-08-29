//
//  HHQuestion.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHQuestion : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *questionId;
@property (nonatomic, copy) NSString *questionDes;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *item1;
@property (nonatomic, copy) NSString *item2;
@property (nonatomic, copy) NSString *item3;
@property (nonatomic, copy) NSString *item4;
@property (nonatomic, copy) NSString *explains;
@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, copy) NSNumber *answered;
@property (nonatomic, copy) NSMutableArray *userAnswers;

- (BOOL)isAnswerCorrect:(NSMutableArray *)answers;
- (NSString *)getQuestionTypeString;
- (BOOL)hasImage;
- (NSArray *)standardAnswers;;

@end