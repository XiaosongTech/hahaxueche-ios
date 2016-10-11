//
//  HHPriceItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPriceItemView : UIView

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *licenseTypeView;
@property (nonatomic, strong) UIImageView *productTypeView;
@property (nonatomic, strong) UIButton *priceDetailButton;
@property (nonatomic, strong) UIView *topLine;


- (void)setupWithPrice:(NSNumber *)price licenseImage:(UIImage *)licenseImage productImage:(UIImage *)productImage detailText:(NSString *)detailText;

@end
