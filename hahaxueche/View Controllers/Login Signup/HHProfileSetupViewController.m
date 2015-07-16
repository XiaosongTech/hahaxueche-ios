//
//  HHProfileSetupViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHProfileSetupViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHRootViewController.h"
#import "HHButton.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"
#import "UIView+HHRect.h"

@interface HHProfileSetupViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *uploadImageView;
@property (nonatomic, strong) HHTextFieldView *nameTextView;
@property (nonatomic, strong) HHTextFieldView *cityTextView;
@property (nonatomic, strong) UIPickerView *cityPicker;

@end

@implementation HHProfileSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *doneButton = [UIBarButtonItem buttonItemWithTitle:@"完成" action:@selector(doneButtonPressed) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    
     UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancelButtonPressed) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.title = @"2/2";
    
    [self initSubviews];
}

- (void)initSubviews {
    [self initUploadIamgeView];
    [self initFieldView];
    [self autolayoutSubviews];
}

- (void)initUploadIamgeView {
    self.uploadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.uploadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.uploadImageView.userInteractionEnabled = YES;
    self.uploadImageView.contentMode = UIViewContentModeCenter;
    self.uploadImageView.image = [UIImage imageNamed:@"camera-alt"];
    self.uploadImageView.layer.cornerRadius = 30.0f;
    self.uploadImageView.layer.masksToBounds = YES;
    self.uploadImageView.layer.borderColor = [UIColor HHOrange].CGColor;
    self.uploadImageView.layer.borderWidth = 1.0f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
    [self.uploadImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.uploadImageView];

}

- (void)initFieldView {
    self.nameTextView = [[HHTextFieldView alloc] initWithPlaceholder:@"姓名"];
    self.nameTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextView.textField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextView.textField.delegate = self;
    [self.nameTextView.textField becomeFirstResponder];
    [self.view addSubview:self.nameTextView];
    
    self.cityTextView = [[HHTextFieldView alloc] initWithPlaceholder:@"所在城市"];
    self.cityTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cityTextView.textField setEnabled:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCity)];
    [self.cityTextView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.cityTextView];
}

- (void)autolayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.uploadImageView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.uploadImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.uploadImageView multiplier:0 constant:60.0f],
                             [HHAutoLayoutUtility setViewHeight:self.uploadImageView multiplier:0 constant:60.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.nameTextView toView:self.uploadImageView constant:5.0f],
                             [HHAutoLayoutUtility setCenterX:self.nameTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.nameTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.nameTextView multiplier:0 constant:30.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.cityTextView toView:self.nameTextView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.cityTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.cityTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.cityTextView multiplier:0 constant:30.0f],
                             ];
    [self.view addConstraints:constraints];

}

- (void)doneButtonPressed {
    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage {
    [self.nameTextView resignFirstResponder];
    if (self.cityPicker) {
        [self.cityPicker removeFromSuperview];
        self.cityPicker = nil;
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameTextView.textField]) {
        if (self.cityPicker) {
            [self.cityPicker removeFromSuperview];
            self.cityPicker = nil;
        }
        self.cityTextView.divideLine.backgroundColor = [UIColor colorWithRed:0.52 green:0.45 blue:0.36 alpha:1];
        self.nameTextView.divideLine.backgroundColor = [UIColor HHOrange];
    }
   
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.nameTextView.divideLine.backgroundColor = [UIColor colorWithRed:0.52 green:0.45 blue:0.36 alpha:1];
}

- (void)selectCity {
    [self.nameTextView.textField resignFirstResponder];
    self.cityTextView.divideLine.backgroundColor = [UIColor HHOrange];
    self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-200.0f, CGRectGetWidth(self.view.bounds), 200.0f)];
     self.cityPicker.delegate = self;
     self.cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview: self.cityPicker];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 5;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return @"杭州";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    self.cityTextView.textField.text = @"杭州";
}


@end
