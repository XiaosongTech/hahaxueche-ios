//
//  HHGetNumberTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHGradientButton.h"

typedef void (^HHGetNumBlock)(NSString *phoneNum);

@interface HHGetNumberTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) HHGradientButton *confirmButton;
@property (nonatomic, strong) HHGetNumBlock confirmBlock;

@end
