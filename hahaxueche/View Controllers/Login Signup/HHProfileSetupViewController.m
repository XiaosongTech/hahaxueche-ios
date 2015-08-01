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
#import "HHToastUtility.h"
#import "HHStudent.h"
#import "HHUserAuthenticator.h"
#import "HHLoadingView.h"

typedef enum : NSUInteger {
    ImageOptionTakePhoto,
    ImageOptionFromAlbum,
} ImageOption;

@interface HHProfileSetupViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *uploadImageView;
@property (nonatomic, strong) HHTextFieldView *nameTextView;
@property (nonatomic, strong) HHTextFieldView *cityTextView;
@property (nonatomic, strong) UIPickerView *cityPicker;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) HHStudent *student;
@property (nonatomic, strong) HHUser *user;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedProvince;



@end

@implementation HHProfileSetupViewController

- (instancetype)initWithUser:(HHUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.selectedCity = @"武汉市";
        self.selectedProvince = @"湖北省";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *doneButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"完成",nil) action:@selector(doneButtonPressed) target:self isLeft:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    
     UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:NSLocalizedString(@"取消",nil) action:@selector(cancelButtonPressed) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.title = NSLocalizedString(@"个人信息",nil);
    [self initSubviews];
}

- (void)initSubviews {
    [self initUploadIamgeView];
    [self initFieldView];
    [self autolayoutSubviews];
    self.cityTextView.textField.text = NSLocalizedString(@"湖北省-武汉市",nil);
}

- (void)initUploadIamgeView {
    self.uploadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.uploadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.uploadImageView.userInteractionEnabled = YES;
    self.uploadImageView.contentMode = UIViewContentModeCenter;
    self.uploadImageView.image = [UIImage imageNamed:@"camera-alt"];
    self.uploadImageView.layer.cornerRadius = 25.0f;
    self.uploadImageView.layer.masksToBounds = YES;
    self.uploadImageView.layer.borderColor = [UIColor HHTransparentWhite].CGColor;
    self.uploadImageView.layer.borderWidth = 1.0f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
    [self.uploadImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.uploadImageView];

}

- (void)initFieldView {
    self.nameTextView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"姓名",nil)];
    self.nameTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextView.textField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextView.textField.delegate = self;
    [self.nameTextView.textField becomeFirstResponder];
    [self.view addSubview:self.nameTextView];
    
    self.cityTextView = [[HHTextFieldView alloc] initWithPlaceholder:NSLocalizedString(@"所在城市",nil)];
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
                             [HHAutoLayoutUtility setViewWidth:self.uploadImageView multiplier:0 constant:50.0f],
                             [HHAutoLayoutUtility setViewHeight:self.uploadImageView multiplier:0 constant:50.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.nameTextView toView:self.uploadImageView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.nameTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.nameTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.nameTextView multiplier:0 constant:40.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.cityTextView toView:self.nameTextView constant:10.0f],
                             [HHAutoLayoutUtility setCenterX:self.cityTextView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.cityTextView multiplier:1.0f constant:-80.0f],
                             [HHAutoLayoutUtility setViewHeight:self.cityTextView multiplier:0 constant:40.0f],
                             ];
    [self.view addConstraints:constraints];

}

- (void)doneButtonPressed {
    if (!self.selectedImage) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请选择头像",nil) isError:YES];
        return;
    }
    if ([self.nameTextView.textField.text isEqualToString: @""]) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请填写名字",nil) isError:YES];
        return;
    }
    if (!self.selectedCity || !self.selectedProvince) {
        [HHToastUtility showToastWitiTitle:NSLocalizedString(@"请选择所在城市和省份",nil) isError:YES];
        return;
    }
    [self.nameTextView.textField resignFirstResponder];
    [[HHLoadingView sharedInstance] showLoadingViewWithTilte:NSLocalizedString(@"创建账户...",nil)];
    NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
    AVFile *imageFile = [AVFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"图片上传失败！",nil) isError:YES];
            [[HHLoadingView sharedInstance] hideLoadingView];
        } else {
            self.student.avatarURL = imageFile.url;
            [self.student saveInBackground];
        }
    }];
    
    self.student = [HHStudent object];
    self.student.fullName = self.nameTextView.textField.text;
    self.student.city = self.selectedCity;
    self.student.province = self.selectedProvince;
    [[HHUserAuthenticator sharedInstance] signupWithUser:self.user completion:^(NSError *error) {
        if (!error) {
            [[HHUserAuthenticator sharedInstance] createStudentWithStudent:self.student completion:^(NSError *error) {
                [[HHLoadingView sharedInstance] hideLoadingView];
                if (!error) {
                    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
                    [self presentViewController:rootVC animated:YES completion:nil];
                } else {
                    [HHToastUtility showToastWitiTitle:NSLocalizedString(@"创建账户失败！",nil) isError:YES];
                }
            }];

        } else {
            [HHToastUtility showToastWitiTitle:NSLocalizedString(@"创建账户失败！",nil) isError:YES];
        }
    }];
}

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage {
    [self.nameTextView.textField resignFirstResponder];
    if (self.cityPicker) {
        [self.cityPicker removeFromSuperview];
        self.cityPicker = nil;
    }
    
    NSString *actionSheetTitle = NSLocalizedString(@"上传头像",nil);
    NSString *other1 = NSLocalizedString(@"拍摄",nil);
    NSString *other2 = NSLocalizedString(@"从相册选择",nil);
    NSString *cancelTitle = NSLocalizedString(@"取消",nil);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    
    [actionSheet showInView:self.view];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameTextView.textField]) {
        if (self.cityPicker) {
            [self.cityPicker removeFromSuperview];
            self.cityPicker = nil;
        }
        self.cityTextView.divideLine.backgroundColor = [UIColor HHTransparentWhite];
        self.nameTextView.divideLine.backgroundColor = [UIColor whiteColor];
    }
   
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.nameTextView.divideLine.backgroundColor = [UIColor HHTransparentWhite];
}

- (void)selectCity {
    [self.nameTextView.textField resignFirstResponder];
    self.cityTextView.divideLine.backgroundColor = [UIColor whiteColor];
    if (!self.cityPicker) {
        self.cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-200.0f, CGRectGetWidth(self.view.bounds), 200.0f)];
    }
    
     self.cityPicker.delegate = self;
     self.cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview: self.cityPicker];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pickerView.bounds), 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Normal" size:20.0f];
    if (component == 0) {
        label.text = @"湖北省";
    } else {
        label.text = @"武汉市";
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case ImageOptionTakePhoto:{
            [self showImagePickerView:UIImagePickerControllerSourceTypeCamera];
        }
            break;
            
        case ImageOptionFromAlbum:{
            [self showImagePickerView:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
            
        default:
            break;
    }
}

- (void)showImagePickerView:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.navigationItem.title = NSLocalizedString(@"头像照片",nil);
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    if(!self.selectedImage) {
        self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.uploadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.uploadImageView.layer.borderWidth = 0;
    self.uploadImageView.image = self.selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
