//
//  HHBonusAmountView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBonusAmountView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithNumber:(NSNumber *)number title:(NSString *)title boldNumber:(BOOL)boldNumber showArror:(BOOL)showArror;

@end
