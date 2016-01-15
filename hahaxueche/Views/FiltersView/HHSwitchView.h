//
//  HHSwitchView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSwitchView : UIView

@property (nonatomic, strong) UISwitch *toggle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

- (instancetype)initWithTitle:(NSString *)title isToggleOn:(BOOL)isToggleOn;

@end
