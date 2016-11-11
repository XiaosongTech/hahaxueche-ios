//
//  HHVoucherView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHVoucher.h"

@interface HHVoucherView : UIView

- (instancetype)initWithVoucher:(HHVoucher *)voucher;

@property (nonatomic, strong) UIImageView *lefImgView;
@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end
