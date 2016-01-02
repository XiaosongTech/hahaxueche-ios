//
//  HHButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHButton.h"
#import "UIColor+HHColor.h"

@implementation HHButton

- (void)HHWhiteBorderButton {
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)HHOrangeTextButton {
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
}

@end
