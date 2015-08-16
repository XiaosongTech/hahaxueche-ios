//
//  HHMobilePhoneViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PageTypeLogin,
    PageTypeSignup,
} PageType;

@interface HHMobilePhoneViewController : UIViewController

- (instancetype)initWithType:(PageType)type;

@end
