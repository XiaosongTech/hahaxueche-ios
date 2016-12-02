//
//  HHQuestion.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HHQuestion : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *questionDes;
@property (nonatomic, copy) NSArray *options;
@property (nonatomic, copy) NSArray *correctAnswers;
@property (nonatomic, copy) NSString *explains;
//0=无; 1=img; 2=video
@property (nonatomic, copy) NSString *mediaType;
@property (nonatomic, copy) NSString *mediaURL;
@property (nonatomic, copy) NSNumber *answered;
@property (nonatomic, copy) NSString *optionType;
@property (nonatomic, copy) NSMutableArray *userAnswers;

- (BOOL)isAnswerCorrect:(NSMutableArray *)answers;
- (NSString *)getQuestionTypeString;


@end
