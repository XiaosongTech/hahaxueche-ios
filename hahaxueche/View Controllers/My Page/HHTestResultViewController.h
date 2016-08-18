//
//  HHTestResultViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTestQuestionManager.h"

@interface HHTestResultViewController : UIViewController

- (instancetype)initWithCorrectQuestions:(NSMutableArray *)correctQuestions min:(NSInteger)min courseMode:(CourseMode)courseMode wrongQuestions:(NSMutableArray *)wrongQuestions;

@property (nonatomic, strong) NSMutableArray *correctQuestions;
@property (nonatomic, strong) NSMutableArray *wrongQuestions;
@property (nonatomic) NSInteger min;
@property (nonatomic) CourseMode courseMode;

@end
