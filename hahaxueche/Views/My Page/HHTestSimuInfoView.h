//
//  HHTestSimuInfoView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/16/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTestSimuInfoView : UIView

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value showBotLine:(BOOL)showBotLine;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *botLine;

@end
