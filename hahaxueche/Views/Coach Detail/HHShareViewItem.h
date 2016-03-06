//
//  HHShareViewItem.h
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHShareViewItem : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
