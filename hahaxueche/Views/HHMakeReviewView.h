//
//  HHMakeReviewView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStarRatingView.h"
#import "HHConfirmCancelButtonsView.h"

@interface HHMakeReviewView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@end
