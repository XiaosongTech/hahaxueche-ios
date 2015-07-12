//
//  HHTextFieldView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *divideLine;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@end
