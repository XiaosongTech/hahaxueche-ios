//
//  HHGenericOneButtonPopupView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHOkButtonView.h"
#import "HHGenericTwoButtonsPopupView.h"

@interface HHGenericOneButtonPopupView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) HHOkButtonView *buttonView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableAttributedString *info;


@property (nonatomic, strong) HHPopupBlock cancelBlock;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title info:(NSMutableAttributedString *)info;

@end
