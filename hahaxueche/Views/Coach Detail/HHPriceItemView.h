//
//  HHPriceItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHPriceDetailBlock)();

@interface HHPriceItemView : UIView

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *priceDetailButton;
@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) HHPriceDetailBlock priceDetailBlock;

- (void)setupWithPrice:(NSNumber *)price iconImage:(UIImage *)iconImage marketPrice:(NSNumber *)marketPrice detailText:(NSString *)detailText;

@end
