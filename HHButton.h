//
//  HHButton.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHButton : UIButton

- (HHButton *)initFloatButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color;
- (HHButton *)initDropDownButtonWithTitle:(NSString *)title frame:(CGRect)frame;
- (HHButton *)initThinBorderButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font;

@end
