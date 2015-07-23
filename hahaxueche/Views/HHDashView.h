//
//  HHDashView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLineColor [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]

@interface HHDashView : UIView

- (instancetype)initWithValueTextColor:(UIColor *)textColor rightLine:(BOOL)rightLine;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *rightLine;

-(void)setupViewWithKey:(NSString *)key value:(NSString *)value;

@end
