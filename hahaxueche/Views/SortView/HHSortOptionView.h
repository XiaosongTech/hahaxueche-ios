//
//  HHSortOptionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/15/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@interface HHSortOptionView : UIView

- (instancetype)initWithTilte:(NSString *)title image:(UIImage *)image highlightImage:(UIImage *)highlightImage;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightImage;

- (void)setupView:(BOOL)highlight;

@end
