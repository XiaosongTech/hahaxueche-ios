//
//  HHShareReferralView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 25/02/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHShareReferralBlock)();

@interface HHShareReferralView : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@property (nonatomic, strong) UIImageView *giftView;
@property (nonatomic, strong) UIImageView *topBgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *botContainerView;

@property (nonatomic, strong) HHShareReferralBlock shareBlock;

@end
