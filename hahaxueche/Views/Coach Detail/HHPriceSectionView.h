//
//  HHPriceSectionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 29/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHPriceLicenseTypeAction)();

@interface HHPriceSectionView : UIView

- (instancetype)initWithTitle:(NSString *)title price:(NSNumber *)price VIPPrice:(NSNumber *)VIPPrice;

- (instancetype)initWithTitle:(NSString *)title prices:(NSArray *)prices;

@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *botLine;

@property (nonatomic, strong) NSMutableArray *priceViewArray;

@property (nonatomic, strong) HHPriceLicenseTypeAction questionAction;

@end
