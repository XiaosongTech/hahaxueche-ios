//
//  HHOptionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHOptionView : UIView

- (instancetype)initWithOptionTilte:(NSString *)title text:(NSString *)text;

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *textLabel;

@end
