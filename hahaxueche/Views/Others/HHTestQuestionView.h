//
//  HHTestQuestionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/11/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHQuestion.h"

typedef void (^HHTestQuestionFavBlock)(HHQuestion *question);

@interface HHTestQuestionView : UIView

- (void)fillUpViewWithQuestion:(HHQuestion *)question favorated:(BOOL)favorated;
- (void)setupFavViews:(BOOL)favorated;

@property (nonatomic, strong) HHTestQuestionFavBlock favBlock;



@end
