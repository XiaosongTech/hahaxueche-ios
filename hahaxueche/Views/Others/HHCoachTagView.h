//
//  HHCoachTagView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHCoachTagView : UIView

@property (nonatomic, strong) UIView *dot;
@property (nonatomic, strong) UILabel *label;


- (void)setDotColor:(UIColor *)dotColor title:(NSString *)title;

@end
