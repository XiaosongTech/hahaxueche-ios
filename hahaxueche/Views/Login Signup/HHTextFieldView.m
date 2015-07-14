//
//  HHTextFieldView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTextFieldView.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"

@implementation HHTextFieldView

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textColor = [UIColor darkTextColor];
        self.textField.tintColor = [UIColor HHOrange];
        self.textField.delegate = self;
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:15.0f]}];
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.textField];
        
        self.divideLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.divideLine.translatesAutoresizingMaskIntoConstraints = NO;
        self.divideLine.backgroundColor = [UIColor colorWithRed:0.52 green:0.45 blue:0.36 alpha:1];
        [self addSubview:self.divideLine];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.textField constant:0],
                             [HHAutoLayoutUtility setCenterX:self.textField multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.textField multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.textField multiplier:1.0f constant:-5.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.divideLine constant:-2.0f],
                             [HHAutoLayoutUtility setCenterX:self.divideLine multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.divideLine multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.divideLine multiplier:0 constant:1.0f],

                             
                             ];
    [self addConstraints:constraints];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.divideLine.backgroundColor = [UIColor HHOrange];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.divideLine.backgroundColor = [UIColor colorWithRed:0.52 green:0.45 blue:0.36 alpha:1];
}



@end
