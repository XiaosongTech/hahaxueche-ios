//
//  HHCityViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 8/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBank.h"

typedef void (^HHBankBlock)(HHBank *bank);

@interface HHBankSelectionViewController : UIViewController

- (instancetype)initWithPopularbanks:(NSArray *)popularBanks allBanks:(NSArray *)allBanks selectedBank:(HHBank *)selectedBank;

@property (nonatomic, strong) HHBankBlock block;

@end
