//
//  HHGradientButton.h
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGradientButton : UIButton

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (instancetype)initWithType:(NSInteger)type;

@end
