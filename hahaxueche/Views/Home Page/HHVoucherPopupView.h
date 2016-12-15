//
//  HHVoucherPopupView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHFormatUtility.h"
#import "HHVoucher.h"

typedef void (^HHVoucherBlock)();

@interface HHVoucherPopupView : UIView

- (instancetype)initWithVoucher:(HHVoucher *)voucher;

@property (nonatomic, strong) HHVoucherBlock dismissBlock;
@property (nonatomic, strong) HHVoucherBlock shareBlock;

@end
