//
//  HHReceiptItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHReceiptItemView : UIView

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithFrame:(CGRect)frame keyTitle:(NSString *)keyTitle value:(NSString *)value;

@end
