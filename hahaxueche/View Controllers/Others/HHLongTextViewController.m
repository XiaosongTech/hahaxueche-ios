//
//  HHLongTextViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 01/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHLongTextViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "UIBarButtonItem+HHCustomButton.h"

@interface HHLongTextViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSString *longText;

@end

@implementation HHLongTextViewController

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text {
    self = [super init];
    if (self) {
        self.navTitle = title;
        self.longText = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.textView = [[UITextView alloc] init];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = [UIColor darkTextColor];
    self.textView.text = self.longText;
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
}


- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
