//
//  HHCoachDetailSingleInfoView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCoachDetailCellActionBlock)();

@interface HHCoachDetailSingleInfoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) HHCoachDetailCellActionBlock actionBlock;

- (void)setupViewWithTitle:(NSString *)title image:(UIImage *)image value:(NSString *)value showArrowImage:(BOOL)showArrowImage actionBlock:(HHCoachDetailCellActionBlock)actionBlock;

@end
