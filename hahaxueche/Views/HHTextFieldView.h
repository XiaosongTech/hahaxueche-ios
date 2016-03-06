//
//  HHTextFieldView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic) BOOL showSeparator;

- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder;

- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder rightView:(UIView *)rightView showSeparator:(BOOL)showSeparator;

@end
