//
//  YEXFetchPWDViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/16.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXFetchPWDViewController.h"

@interface YEXFetchPWDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@end

@implementation YEXFetchPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)commitButton:(id)sender {
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"email" equalTo:self.emailText.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array && array.count != 0) {
            [BmobUser requestPasswordResetInBackgroundWithEmail:self.emailText.text];
            [SVProgressHUD showSuccessWithStatus:@"请查收邮件修改密码。"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱地址！"];
        }
    }];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
