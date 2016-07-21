//
//  HHCouponFAQView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

typedef void (^HHCouponFAQViewBlock)(NSURL *url);

@interface HHCouponFAQView : UIView <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *textLabel;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSString *linkText;
@property (nonatomic, strong) NSString *linkURL;

@property (nonatomic, strong) HHCouponFAQViewBlock linkBlock;

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text linkText:(NSString *)linkText linkURL:(NSString *)linkURL;

@end
