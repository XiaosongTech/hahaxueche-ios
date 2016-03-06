//
//  HHOkButtonView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHOkButtonView : UIView

typedef void (^HHOKButtonActionBlock)();

@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) HHOKButtonActionBlock okAction;

@end
