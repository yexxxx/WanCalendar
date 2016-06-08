//
//  YEXSinginViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/13.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXSinginViewController.h"
#import "YEXLoginViewController.h"

@interface YEXSinginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation YEXSinginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sign:(id)sender {
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.userName.text];
    [bUser setPassword:self.password.text];
    [bUser setEmail:self.email.text];
    __weak typeof(self) weakSelf = self;
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            [SVProgressHUD showSuccessWithStatus:@"注册成功\r请登录邮箱验证"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

- (IBAction)login:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
