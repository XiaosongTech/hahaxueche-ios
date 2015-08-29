//
//  HHReceiptTableViewCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/26/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHAvatarView.h"
#import "HHTransaction.h"
#import "HHPaymentStatus.h"

typedef void (^HHReceiptCellGenericActionBlock)();

@interface HHReceiptTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) HHAvatarView *avatarView;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *secondLine;
@property (nonatomic, strong) HHReceiptCellGenericActionBlock nameButtonActionBlock;
@property (nonatomic, strong) HHTransaction *transaction;
@property (nonatomic, strong) HHPaymentStatus *paymentStatus;

@property (nonatomic, strong) NSMutableArray *paymentStatusViewArray;

@end
