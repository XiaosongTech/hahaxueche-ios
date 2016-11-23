//
//  HHUploadIdView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 23/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHUploadIdView : UIView

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *leftView;

@end
