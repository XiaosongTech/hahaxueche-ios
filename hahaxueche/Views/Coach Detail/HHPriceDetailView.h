//
//  HHPriceDetailView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHPriceDetailViewBlock)();

@interface HHPriceDetailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) UILabel *otherFeesLabel;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;
@property (nonatomic, strong) UIButton *okButton;



@property (nonatomic, strong) HHPriceDetailViewBlock cancelBlock;
@property (nonatomic, strong) HHPriceDetailViewBlock confirmBlock;



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title totalPrice:(NSNumber *)totalPrice showOKButton:(BOOL)showOKButton;

@end
