//
//  HHMyPageUserInfoCell.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHStudent.h"
#import "HHMyPageUserInfoView.h"


typedef void (^HHPaymentViewActionBlock)();
typedef void (^HHAvatarViewActionBlock)();

@interface HHMyPageUserInfoCell : UITableViewCell

@property (nonatomic, strong) UIView *avatarBackgroungView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) HHMyPageUserInfoView *balanceView;
@property (nonatomic, strong) HHMyPageUserInfoView *paymentView;
@property (nonatomic, strong) HHPaymentViewActionBlock paymentViewActionBlock;
@property (nonatomic, strong) HHAvatarViewActionBlock avatarViewActionBlock;

@property (nonatomic, strong) UIView *verticalLine;


- (void)setupCellWithStudent:(HHStudent *)student;

@end
