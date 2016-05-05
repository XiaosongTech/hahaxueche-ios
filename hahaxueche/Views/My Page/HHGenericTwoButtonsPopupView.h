//
//  HHConfirmWithdrawView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHPopupBlock)();


@interface HHGenericTwoButtonsPopupView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSMutableAttributedString *info;
@property (nonatomic, strong) NSString *leftButtonTitle;
@property (nonatomic, strong) NSString *rightButtonTitle;

@property (nonatomic, strong) HHPopupBlock confirmBlock;
@property (nonatomic, strong) HHPopupBlock cancelBlock;



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle info:(NSMutableAttributedString *)info leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

@end
