//
//  HHNavBarSegmentedControl.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHNavBarSegmentedControl.h"
#import "UIColor+HHColor.h"

@implementation HHNavBarSegmentedControl

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    if (self) {
        self.tintColor = [UIColor HHOrange];
        NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]};
        NSDictionary *normalAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:0.84 blue:0.62 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
        [self setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        [self setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        
        self.selectedSegmentIndex = 0;
    }
    return self;
}

@end
