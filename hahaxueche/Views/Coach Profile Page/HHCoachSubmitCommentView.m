//
//  HHCoachSubmitCommentView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/16/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHCoachSubmitCommentView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"

@implementation HHCoachSubmitCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = NSLocalizedString(@"给教练打分", nil);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:line];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
        line2.translatesAutoresizingMaskIntoConstraints = NO;
        line2.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:line2];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
        verticalLine.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:verticalLine];
        
        self.reviewTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.reviewTextView.translatesAutoresizingMaskIntoConstraints = NO;
        self.reviewTextView.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f];
        self.reviewTextView.showsHorizontalScrollIndicator = NO;
        self.reviewTextView.delegate = self;
        [self addSubview:self.reviewTextView];
        
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.placeholderLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.text = NSLocalizedString(@"牢骚或表扬，大胆说出来吧！", nil);
        self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
        [self.placeholderLabel sizeToFit];
        [self.reviewTextView addSubview:self.placeholderLabel];
        
        
        UIButton *dismissButton = [self createButtonWithTitle:NSLocalizedString(@"取消返回", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(cancelButtonTapped)];
        [dismissButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        [self addSubview:dismissButton];
        
        UIButton *confirmButton = [self createButtonWithTitle:NSLocalizedString(@"确认评价", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(confirmButtonTapped)];
        [confirmButton setTitleColor:[UIColor HHBlueButtonColor] forState:UIControlStateNormal];
        [self addSubview:confirmButton];
        
        self.ratingView = [[HHStarRatingView alloc] initWithFrame:CGRectZero rating:0];
        self.ratingView.userInteractionEnabled = YES;
        self.ratingView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.ratingView];
        
        NSArray *constraints = @[
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:titleLabel constant:15.0f],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:titleLabel constant:15.0f],
                                 
                                 [HHAutoLayoutUtility setCenterY:self.ratingView toView:titleLabel multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.ratingView constant:-10.0f],
                                 [HHAutoLayoutUtility setViewHeight:self.ratingView multiplier:0 constant:45.0f],
                                 [HHAutoLayoutUtility setViewWidth:self.ratingView multiplier:0 constant:110.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:line constant:45.0f],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line constant:0],
                                 [HHAutoLayoutUtility setViewWidth:line multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:line multiplier:0 constant:1.0f],
                                 
                                 
                                 [HHAutoLayoutUtility verticalNext:self.reviewTextView toView:line constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.reviewTextView constant:10.0f],
                                 [HHAutoLayoutUtility setViewWidth:self.reviewTextView multiplier:1.0f constant:-30.0f],
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.reviewTextView constant:-46.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:line2 constant:-45.0f],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line2 constant:0],
                                 [HHAutoLayoutUtility setViewWidth:line2 multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:line2 multiplier:0 constant:1.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:dismissButton constant:0],
                                 [HHAutoLayoutUtility setCenterX:dismissButton multiplier:0.5f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:dismissButton multiplier:0.5f constant:-1.0f],
                                 [HHAutoLayoutUtility setViewHeight:dismissButton multiplier:0 constant:45.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:confirmButton constant:0],
                                 [HHAutoLayoutUtility setCenterX:confirmButton multiplier:1.5f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:confirmButton multiplier:0.5f constant:-1.0f],
                                 [HHAutoLayoutUtility setViewHeight:confirmButton multiplier:0 constant:45.0f],
                                 
                                 
                                 
                                 [HHAutoLayoutUtility setCenterY:verticalLine multiplier:2.0f constant:-45.0f/2.0f],
                                 [HHAutoLayoutUtility setCenterX:verticalLine multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:verticalLine multiplier:0 constant:1.0f],
                                 [HHAutoLayoutUtility setViewHeight:verticalLine multiplier:0 constant:30.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.placeholderLabel constant:10.0f],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.placeholderLabel constant:6.0f],
                                 
                                 ];
        
        
        [self addConstraints:constraints];
        [self.reviewTextView becomeFirstResponder];
    }
    return self;
}


- (UIButton *)createButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor font:(UIFont *)font action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:bgColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma -mark TextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)cancelButtonTapped {
    if (self.cancelAction) {
        self.cancelAction();
    }
}

- (void)confirmButtonTapped {
    if (self.confirmAction) {
        self.confirmAction();
    }
}


@end
