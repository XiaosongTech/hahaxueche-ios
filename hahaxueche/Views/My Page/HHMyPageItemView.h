//
//  HHMyPageItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/18/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHMyPageItemActionBlock)();

@interface HHMyPageItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UIView *redDot;

@property (nonatomic, strong) HHMyPageItemActionBlock actionBlock;

- (instancetype)initWitTitle:(NSString *)title showLine:(BOOL)showLine;

@end
