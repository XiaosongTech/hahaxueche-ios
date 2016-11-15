//
//  HHVoucherSelectTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 14/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVoucherSelectTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHVoucherSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor HHBackgroundGary];
    }
    return self;
}


- (void)setupCellWithVoucher:(HHVoucher *)voucher selected:(BOOL)selected {
    if (!self.checkView) {
        self.checkView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.checkView];
    }
    if (selected) {
        self.checkView.image = [UIImage imageNamed:@"icon_selected_press"];
    } else {
        self.checkView.image = [UIImage imageNamed:@"icon_selected_normal"];
    }
    [self.checkView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY).offset(7.5f);
        make.right.equalTo(self.contentView.right).offset(-15.0f);
        make.width.mas_equalTo(22.0f);
        make.height.mas_equalTo(22.0f);
    }];
    
    if (self.voucherView) {
        [self.voucherView removeFromSuperview];
        self.voucherView = nil;
    }
    self.voucherView = [[HHVoucherView alloc] initWithVoucher:voucher];
    [self.contentView addSubview:self.voucherView];
    [self.voucherView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(15.0f);
        make.left.equalTo(self.contentView.left).offset(15.0f);
        make.height.mas_equalTo(90.0f);
        make.right.equalTo(self.checkView.left).offset(-15.0f);
    }];
}


@end
