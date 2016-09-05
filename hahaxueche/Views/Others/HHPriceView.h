//
//  HHPriceView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPriceView : UIView

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle price:(NSNumber *)price;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *topLine;

@end
