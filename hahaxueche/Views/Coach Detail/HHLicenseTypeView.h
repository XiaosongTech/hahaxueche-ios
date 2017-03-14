//
//  HHLicenseTypeView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 08/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHCoachPriceLicenseTypeAction)();

@interface HHLicenseTypeView : UIView

//1=c1 2=c2
- (instancetype)initWithType:(NSInteger)type selected:(BOOL)selected alignLeft:(BOOL)alignLeft;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *questionButton;

@property (nonatomic, strong) HHCoachPriceLicenseTypeAction selectedBlock;
@property (nonatomic, strong) HHCoachPriceLicenseTypeAction questionMarkBlock;

@end
