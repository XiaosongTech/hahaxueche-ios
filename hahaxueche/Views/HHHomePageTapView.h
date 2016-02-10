//
//  HHHomePageTapView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHHomePageTapViewBlock)();

@interface HHHomePageTapView : UIView

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *arrowIcon;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;

@property(nonatomic, strong) HHHomePageTapViewBlock actionBlock;

@end
