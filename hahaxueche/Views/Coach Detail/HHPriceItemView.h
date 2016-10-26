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
@property (nonatomic, strong) UILabel *licenseTypeLabel;
@property (nonatomic, strong) UILabel *productTypeLabel;
@property (nonatomic, strong) UIButton *priceDetailButton;
@property (nonatomic, strong) UIView *topLine;


- (void)setupWithPrice:(NSNumber *)price licenseType:(NSInteger)licenseType productText:(NSString *)productText detailText:(NSString *)detailText;

@end
