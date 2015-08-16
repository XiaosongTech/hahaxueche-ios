//
//  HHDashView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHDashView : UIView

- (instancetype)initWithValueTextColor:(UIColor *)textColor rightLine:(BOOL)rightLine;

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *rightLine;

-(void)setupViewWithKey:(NSString *)key value:(NSString *)value;

@end
