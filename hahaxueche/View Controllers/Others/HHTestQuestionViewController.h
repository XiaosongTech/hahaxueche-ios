//
//  HHTestQuestionViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHTestQuestionManager.h"

typedef void (^HHReferSharePopupBlock)();

@interface HHTestQuestionViewController : UIViewController

- (instancetype)initWithTestMode:(TestMode)testMode courseMode:(CourseMode)courseMode questions:(NSMutableArray *)questions startIndex:(NSInteger)startIndex;

@property (nonatomic, strong) HHReferSharePopupBlock dismissBlock;

@end
