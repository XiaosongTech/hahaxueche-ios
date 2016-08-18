//
//  HHAddBankCardViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBankCard.h"

typedef void (^HHBankCardBlock)(HHBankCard *card);

@interface HHAddBankCardViewController : UIViewController

- (instancetype)initWithCard:(HHBankCard *)card;

@property (nonatomic, strong) HHBankCardBlock cardBlock;

@end
