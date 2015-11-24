//
//  HHQRCodeScannerViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 11/24/15.
//  Copyright © 2015 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBXScanView.h"
#import "LBXScanWrapper.h"

typedef void (^HHQRCodeScanResult)(NSArray<LBXScanResult *> *results);

@interface HHQRCodeScannerViewController : UIViewController

@property (nonatomic,strong) LBXScanWrapper* scanObj;

@property (nonatomic,strong) LBXScanView* qRScanView;

@property (nonatomic, strong) HHQRCodeScanResult resultBlock;

@property (nonatomic, strong) UIButton *cancelButton;

@end
