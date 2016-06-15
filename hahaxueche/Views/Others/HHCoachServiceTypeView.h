//
//  HHCoachServiceTypeView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHPriceBlock)();

@interface HHCoachServiceTypeView : UIView

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *marketPriceLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *priceDetailButton;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *selectionView;

@property (nonatomic) BOOL selected;

@property (nonatomic, strong) HHPriceBlock priceBlock;

- (instancetype)initWithPrice:(NSNumber *)price iconImage:(UIImage *)iconImage marketPrice:(NSNumber *)marketPrice detailText:(NSString *)detailText selected:(BOOL)selected;

@end
