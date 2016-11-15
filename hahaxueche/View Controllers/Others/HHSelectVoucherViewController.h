//
//  HHSelectVoucherViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 14/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHVoucherBlock)(NSInteger selectedIndex);

@interface HHSelectVoucherViewController : UIViewController

- (instancetype)initWithVouchers:(NSArray *)vouchers selectedIndex:(NSInteger)index;

@property (nonatomic, strong) HHVoucherBlock selectedBlock;

@end
