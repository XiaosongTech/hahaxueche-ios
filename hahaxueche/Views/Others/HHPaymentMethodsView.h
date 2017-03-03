//
//  HHPaymentMethodsViwe.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHPaymentService.h"

@interface HHPaymentMethodsView : UIView

@property (nonatomic) StudentPaymentMethod selectedMethod;
@property (nonatomic, strong) NSMutableArray *views;

@end
