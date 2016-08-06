//
//  HHCardInfoInputView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCardInfoViewBlock)();


@interface HHCardInfoInputView : UIView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) HHCardInfoViewBlock block;


@end
