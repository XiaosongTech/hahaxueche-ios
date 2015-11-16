//
//  HHTryCoachSubmitView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/16/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHTryCoachSubmitView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "UIView+HHRect.h"

@implementation HHTryCoachSubmitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = NSLocalizedString(@"确认试学后，教练会通过电话联系您。", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        self.nameField = [self createTextFieldWithPlaceHolder:NSLocalizedString(@"您的姓名", nil)];
        self.numberField = [self createTextFieldWithPlaceHolder:NSLocalizedString(@"联系方式", nil)];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:line];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
        line2.translatesAutoresizingMaskIntoConstraints = NO;
        line2.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:line2];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectZero];
        line3.translatesAutoresizingMaskIntoConstraints = NO;
        line3.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:line3];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        verticalLine.translatesAutoresizingMaskIntoConstraints = NO;
        verticalLine.backgroundColor = [UIColor HHGrayLineColor];
        [self addSubview:verticalLine];
        
        UIButton *dismissButton = [self createButtonWithTitle:NSLocalizedString(@"取消返回", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(cancelButtonTapped)];
        [dismissButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        [self addSubview:dismissButton];
        
        UIButton *confirmButton = [self createButtonWithTitle:NSLocalizedString(@"确认试学", nil) backgroundColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0f] action:@selector(confirmButtonTapped)];
        [confirmButton setTitleColor:[UIColor HHBlueButtonColor] forState:UIControlStateNormal];
        [self addSubview:confirmButton];
        
        NSArray *constraints = @[
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:titleLabel constant:0],
                                 [HHAutoLayoutUtility setCenterX:titleLabel multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:titleLabel multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:titleLabel multiplier:0 constant:50.0f],
                                 
                                 [HHAutoLayoutUtility verticalAlignToSuperViewTop:line constant:50.0f],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line constant:0],
                                 [HHAutoLayoutUtility setViewWidth:line multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:line multiplier:0 constant:1.0f],
                                 
                                 [HHAutoLayoutUtility verticalNext:self.nameField toView:line constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.nameField constant:15.0f],
                                 [HHAutoLayoutUtility setViewHeight:self.nameField multiplier:0 constant:50.0f],
                                 [HHAutoLayoutUtility setViewWidth:self.nameField multiplier:1.0f constant:-15.0f],
                                 
                                 [HHAutoLayoutUtility verticalNext:line2 toView:self.nameField constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line2 constant:15.0f],
                                 [HHAutoLayoutUtility setViewWidth:line2 multiplier:1.0f constant:-15.0f],
                                 [HHAutoLayoutUtility setViewHeight:line2 multiplier:0 constant:1.0f],
                                 
                                 [HHAutoLayoutUtility verticalNext:self.numberField toView:line2 constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.numberField constant:15.0f],
                                 [HHAutoLayoutUtility setViewHeight:self.numberField multiplier:0 constant:50.0f],
                                 [HHAutoLayoutUtility setViewWidth:self.numberField multiplier:1.0f constant:-15.0f],
                                 
                                 [HHAutoLayoutUtility verticalNext:line3 toView:self.numberField constant:0],
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:line3 constant:0],
                                 [HHAutoLayoutUtility setViewWidth:line3 multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewHeight:line3 multiplier:0 constant:1.0f],
                                 
                                 [HHAutoLayoutUtility verticalNext:dismissButton toView:line3 constant:0],
                                 [HHAutoLayoutUtility setCenterX:dismissButton multiplier:0.5f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:dismissButton multiplier:0.5f constant:-1.0f],
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:dismissButton constant:0],
                                 
                                 [HHAutoLayoutUtility verticalNext:confirmButton toView:line3 constant:0],
                                 [HHAutoLayoutUtility setCenterX:confirmButton multiplier:1.5f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:confirmButton multiplier:0.5f constant:-1.0f],
                                 [HHAutoLayoutUtility verticalAlignToSuperViewBottom:confirmButton constant:0],
                                 
                                 
                                 [HHAutoLayoutUtility setCenterY:verticalLine multiplier:2.0f constant:-50.0f/2.0f],
                                 [HHAutoLayoutUtility setCenterX:verticalLine multiplier:1.0f constant:0],
                                 [HHAutoLayoutUtility setViewWidth:verticalLine multiplier:0 constant:1.0f],
                                 [HHAutoLayoutUtility setViewHeight:verticalLine multiplier:0 constant:30.0f],
                                 
                                 
                                 ];
        
        
        [self addConstraints:constraints];
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

- (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = placeHolder;
    [self addSubview:textField];
    return textField;
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
