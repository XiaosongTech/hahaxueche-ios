//
//  HHHomePageItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHomePageItemView : UIView

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title;

@property (nonatomic, strong) UIView *dot;
@property (nonatomic, strong) UILabel *label;

@end
