//
//  YEXLoginViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/13.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXLoginViewController.h"
#import "YEXSinginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "YEXFetchPWDViewController.h"

@interface YEXLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@end

@implementation YEXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameText.delegate = self;
    self.pwdText.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sign:(id)sender {
    YEXSinginViewController *signvc = [[YEXSinginViewController alloc] init];
    [self presentViewController:signvc animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    [self setEditing:YES animated:YES];
    __weak typeof(self) weakSelf = self;
    [BmobUser loginInbackgroundWithAccount:self.nameText.text andPassword:self.pwdText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else {
             [SVProgressHUD showInfoWithStatus:error.userInfo[@"error"]];
        }
    }];
}

- (IBAction)forgetPWD:(id)sender {
    YEXFetchPWDViewController *fetchPWD = [[YEXFetchPWDViewController alloc] init];
    [self presentViewController:fetchPWD animated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sinaLogin:(id)sender {
     __weak typeof(self) weakSelf = self;
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             //得到的新浪微博授权信息，请按照例子来生成NSDictionary
             NSDictionary *dic = @{@"access_token":user.credential.token,@"uid":user.uid,@"expirationDate":user.credential.expired};
             //通过授权信息注册登录
             [BmobUser loginInBackgroundWithAuthorDictionary:dic
                                                    platform:BmobSNSPlatformSinaWeibo
                                                       block:^(BmobUser *user, NSError *error) {
                                                           if (user) {
                                                               [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                                               [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                           }else {
                                                               [SVProgressHUD showInfoWithStatus:error.userInfo[@"error"]];
                                                           }
            }];
             
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (IBAction)wechatLogin:(id)sender {
}

#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameText) {
        [self.pwdText becomeFirstResponder];
        return YES;
    } else {
        [textField resignFirstResponder];
        [self login:textField];
        return YES;
    }
}

@end
