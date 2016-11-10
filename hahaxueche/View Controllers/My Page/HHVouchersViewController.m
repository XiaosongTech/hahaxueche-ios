//
//  HHVouchersViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 10/11/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHVouchersViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHVouchersViewController ()

@end

@implementation HHVouchersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代金券";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
}


- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
