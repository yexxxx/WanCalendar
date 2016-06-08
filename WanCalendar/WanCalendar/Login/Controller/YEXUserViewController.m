//
//  YEXUserViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/26.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXUserViewController.h"

@interface YEXUserViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation YEXUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.userName;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sync:(id)sender {
    [SVProgressHUD  showSuccessWithStatus:@"同步成功！"];
}
- (IBAction)logout:(id)sender {
    [BmobUser logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
