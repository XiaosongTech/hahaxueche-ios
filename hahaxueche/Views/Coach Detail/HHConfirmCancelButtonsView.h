//
//  HHConfirmCancelButtonsView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHConfirmCancelButtonsView : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizontalLine;

- (instancetype)initWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;

@end
