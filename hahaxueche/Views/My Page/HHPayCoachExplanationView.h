//
//  HHPayCoachExplanationView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/28/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

@interface HHPayCoachExplanationView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

- (instancetype)initWithFrame:(CGRect)frame amount:(NSNumber *)amount;

@end
