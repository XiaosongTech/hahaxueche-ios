//
//  HHTestView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/9/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HHTestViewBlock)();

@interface HHTestView : UIView

@property (nonatomic, strong) HHTestViewBlock tapBlock;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image showVerticalLine:(BOOL)showVerticalLine showBottomLine:(BOOL)showBottomLine;

@end
