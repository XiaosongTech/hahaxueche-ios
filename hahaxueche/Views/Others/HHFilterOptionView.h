//
//  HHFilterOptionView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 28/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHFilterOptionView : UIView

- (instancetype)initWithTitle:(NSString *)title selected:(BOOL)selected;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;

@end
