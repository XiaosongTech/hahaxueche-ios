//
//  HHAvatarView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHAvatarView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic)         CGFloat radius;

- (instancetype)initWithImage:(UIImage *)image radius:(CGFloat)radius borderColor:(UIColor *)borderColor;

@end
