//
//  HHCourseInsuranceCardViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 01/12/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCourseInsuranceCardViewController.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHCourseInsuranceCardViewController ()

@end

@implementation HHCourseInsuranceCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
}

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
