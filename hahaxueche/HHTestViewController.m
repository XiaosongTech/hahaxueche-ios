//
//  HHTestViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/4/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHTestViewController.h"

@interface HHTestViewController ()

@end

@implementation HHTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *testLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testLable.text = @"hahaxueche";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testLable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
