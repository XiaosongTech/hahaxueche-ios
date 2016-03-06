//
//  HHTryCoachView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHConfirmCancelButtonsView.h"

typedef void (^HHTryCoachConfirmBlock)(NSString *name, NSString *number, NSDate *firstDate, NSDate *secDate);
typedef void (^HHTryCoachCancelBlock)();

@interface HHTryCoachView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UIButton *firstDateButton;
@property (nonatomic, strong) UIButton *secDateButton;

@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *secDate;

@property (nonatomic, strong) HHTryCoachConfirmBlock confirmBlock;
@property (nonatomic, strong) HHTryCoachCancelBlock cancelBlock;

@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;

@end
