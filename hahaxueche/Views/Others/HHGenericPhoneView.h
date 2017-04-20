//
//  HHGenericPhoneView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 19/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHGradientButton.h"

typedef void (^HHButtonAction)(NSString *number);

@interface HHGenericPhoneView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) HHGradientButton *button;

@property (nonatomic, strong) HHButtonAction buttonAction;

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder buttonTitle:(NSString *)buttonTitle;

@end
