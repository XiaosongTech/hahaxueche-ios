//
//  HHGroupPurchaseView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHGroupPurchaseConfirmBlock)(NSString *name, NSString *number);
typedef void (^HHGroupPurchaseCancelBlock)();

@interface HHGroupPurchaseView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) HHGroupPurchaseCancelBlock cancelBlock;

@end
