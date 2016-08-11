//
//  HHTestQuestionBottomBar.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHTestQuestionActionBlock)();

@interface HHTestQuestionBottomBar : UIView

@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong)HHTestQuestionActionBlock prevAction;
@property (nonatomic, strong)HHTestQuestionActionBlock nextAction;

@end
