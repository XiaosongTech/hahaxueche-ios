//
//  HHVoucherSelectTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 14/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHVoucherView.h"

@interface HHVoucherSelectTableViewCell : UITableViewCell

@property (nonatomic, strong) HHVoucherView *voucherView;
@property (nonatomic, strong) UIImageView *checkView;

- (void)setupCellWithVoucher:(HHVoucher *)voucher selected:(BOOL)selected;

@end
