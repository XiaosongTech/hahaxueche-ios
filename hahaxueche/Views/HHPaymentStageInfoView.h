//
//  HHPaymentStageInfoView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHOkButtonView.h"

@interface HHPaymentStageInfoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) HHOkButtonView *okButton;

@property (nonatomic, strong) HHOKButtonActionBlock okAction;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title text:(NSString *)text textColor:(UIColor *)textColor;

@end
