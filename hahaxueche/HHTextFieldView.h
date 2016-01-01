//
//  HHTextFieldView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;

- (HHTextFieldView *)initWithPlaceHolder:(NSString *)placeHolder;

@end
