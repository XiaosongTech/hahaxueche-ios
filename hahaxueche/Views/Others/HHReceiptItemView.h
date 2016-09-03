//
//  HHReceiptItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHReceiptItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;

@end
