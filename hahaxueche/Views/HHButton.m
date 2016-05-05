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

- (void)HHConfirmButton {
    self.backgroundColor = [UIColor clearColor];
    [self setTitle:@"确定" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor HHGreen] forState:UIControlStateNormal];
}

- (void)HHCancelButton {
    self.backgroundColor = [UIColor clearColor];
    [self setTitle:@"取消" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1 green:0.447 blue:0 alpha:1] forState:UIControlStateNormal];
}

- (void)HHOrangeBackgroundWhiteTextButton {
    self.backgroundColor = [UIColor HHOrange];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
