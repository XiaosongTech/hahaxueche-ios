//
//  HHTestQuestionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHQuestion.h"
#import "HHTestQuestionManager.h"

typedef void (^HHTestQuestionFavBlock)(HHQuestion *question);
typedef void (^HHTestQuestionExplanationBlock)(NSURL *url);

@interface HHTestQuestionView : UIView

- (void)fillUpViewWithQuestion:(HHQuestion *)question favorated:(BOOL)favorated testMode:(TestMode)testMode;
- (void)setupFavViews:(BOOL)favorated testMode:(TestMode)testMode;

@property (nonatomic, strong) HHTestQuestionFavBlock favBlock;
@property (nonatomic, strong) HHTestQuestionFavBlock answeredBlock;
@property (nonatomic, strong) HHTestQuestionExplanationBlock explaBlock;


@end
