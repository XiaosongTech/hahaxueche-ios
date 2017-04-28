//
//  HHFilterItemView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 27/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHFilterItemView : UIView

- (instancetype)initWithTitle:(NSString *)title rightLine:(BOOL)rightLine;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic) BOOL hightlighted;

@end
