//
//  HHQRCodeShareView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 13/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHShareViewItem.h"
#import "HHShareView.h"


@interface HHQRCodeShareView : UIView

- (instancetype)initWithTitle:(NSAttributedString *)string qrCodeImg:(UIImage *)img;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIImageView *qrCodeImgView;

@property (nonatomic, strong) HHShareViewBlock selectedBlock;
@property (nonatomic, strong) HHShareViewDissmissBlock dismissBlock;
@end
