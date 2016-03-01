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

static NSString *const kPlaceholder = @"您对哈哈学车的教练还满意吗？在这里写下给教练的评价吧！～";

typedef void (^HHMakeReviewBlock)(NSNumber *rating, NSString *comment);
typedef void (^HHCancelBlock)();

@interface HHMakeReviewView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HHStarRatingView *starRatingView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@property (nonatomic, strong) HHMakeReviewBlock makeReviewBlock;
@property (nonatomic, strong) HHCancelBlock cancelBlock;

@end
