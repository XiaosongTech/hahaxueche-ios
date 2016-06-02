//
//  HHPaymentMethodView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 5/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPaymentMethodView : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *selectionView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle icon:(UIImage *)image selected:(BOOL)selected enabled:(BOOL)enabled;

@end
