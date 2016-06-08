//
//  YEXTimePickerViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/1.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXTimePickerViewController.h"

@interface YEXTimePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (copy, nonatomic)transDateBlock block;

@end

@implementation YEXTimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.cancelButton setTintColor:[UIColor blackColor]];
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSFontAttributeName:textFont}];
    [self.cancelButton setAttributedTitle:attrStr1 forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmButton setTintColor:[UIColor blackColor]];
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName:textFont}];
    [self.confirmButton setAttributedTitle:attrStr2 forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.datePicker setDate:self.currentDate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tagetAction
-(void)cancelButtonClicked:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)confirmButtonClicked:(UIButton *)button {
    
    typeof(self) weakSelf = self;
    if (self.block) {
        self.block(weakSelf.datePicker.date);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)transDate:(transDateBlock)block {
    self.block = block;
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
