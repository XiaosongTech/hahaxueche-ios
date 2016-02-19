//
//  HHMyPageUserInfoView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMyPageUserInfoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

- (void)setupViewWithTitle:(NSString *)title value:(NSString *)value showArrow:(BOOL)showArror;

@end
