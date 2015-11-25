//
//  HHPriceItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 11/24/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import "HHPriceItemView.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"

@implementation HHPriceItemView

- (instancetype)initWithKeyText:(NSString *)keyText valueText:(NSString *)valueText {
    self = [super init];
    if (self) {
        UILabel *keyLable = [self createLabelWithText:keyText font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f] textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self addSubview:keyLable];
        
        UILabel *valueLabel = [self createLabelWithText:valueText font:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f] textColor:[UIColor HHOrange]];
        [self addSubview:valueLabel];
        
        
        NSArray *constraints = @[
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:keyLable constant:0],
                                 [HHAutoLayoutUtility setCenterY:keyLable multiplier:1.0f constant:0],
                                 
                                 [HHAutoLayoutUtility horizontalAlignToSuperViewRight:valueLabel constant:0],
                                 [HHAutoLayoutUtility setCenterY:valueLabel multiplier:1.0f constant:0],
                                 ];
        [self addConstraints:constraints];
        
    }
    return self;
}


- (UILabel *)createLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    [label sizeToFit];
    return label;
}

@end
