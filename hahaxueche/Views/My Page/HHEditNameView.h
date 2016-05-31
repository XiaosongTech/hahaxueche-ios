//
//  HHEditNameView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/31/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

@interface HHEditNameView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name;

@end
