//
//  HHLongImageViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/29/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLongImageViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end
