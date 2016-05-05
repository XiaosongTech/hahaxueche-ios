//
//  HHWithdrawViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 4/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HHBonusSummaryUpdateBlock)(NSNumber *redeemedAmount);

@interface HHWithdrawViewController : UIViewController

- (instancetype)initWithAvailableAmount:(NSNumber *)amount;

@property (nonatomic, strong) HHBonusSummaryUpdateBlock updateAmountsBlock;

@end
