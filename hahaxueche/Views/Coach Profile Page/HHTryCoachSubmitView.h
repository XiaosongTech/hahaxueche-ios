//
//  HHTryCoachSubmitView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/16/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHTryCoachSubmitViewActionBlock)();

@interface HHTryCoachSubmitView : UIView

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) HHTryCoachSubmitViewActionBlock cancelAction;
@property (nonatomic, strong) HHTryCoachSubmitViewActionBlock confirmAction;

@end
