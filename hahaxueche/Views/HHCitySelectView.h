//
//  HHCitySelectView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHButton.h"

@interface HHCitySelectView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHButton *confirmButton;
@property (nonatomic, strong) UIView *bottomLine;

- (instancetype)initWithCities:(NSArray *)cities frame:(CGRect)frame;

@end
