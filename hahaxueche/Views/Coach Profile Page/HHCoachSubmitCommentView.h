//
//  HHCoachSubmitCommentView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/16/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"

typedef void (^HHSubmitCommentViewActionBlock)();

@interface HHCoachSubmitCommentView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *reviewTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) HHStarRatingView *ratingView;
@property (nonatomic, strong) HHSubmitCommentViewActionBlock cancelAction;
@property (nonatomic, strong) HHSubmitCommentViewActionBlock confirmAction;

@end
