//
//  YEXNoteViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/26.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXNoteViewController.h"
#import "YEXNote.h"

@interface YEXNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@end

@implementation YEXNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *leftStr = @"返回";
    NSString *rightStr = @"添加";
    if (self.notePath) {
        self.titleText.text = self.note.title;
        self.contentText.text = self.note.content;
        leftStr = @"删除";
        rightStr = @"修改";
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftStr style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightStr style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor brownColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.titleText resignFirstResponder];
    [self.contentText resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target-action
-(void)leftButtonClicked {
    if (self.notePath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        [fileManager removeItemAtPath:self.notePath error:&error];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)rightButtonClicked {
    if ([self.titleText.text isEqualToString:@""] || !self.titleText.text) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        alert.title = @"请输入标题！";
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
    dateFormer.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    self.note.title = self.titleText.text;
    self.note.content = self.contentText.text;
    self.note.creatTime = [dateFormer stringFromDate:[NSDate date]];
    if (self.notePath) {
        if ([NSKeyedArchiver archiveRootObject:self.note toFile:self.notePath]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        //获取document路径
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        //获取fileManager
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //文件夹名字为当天日期，如：2016-06-07
        NSString *fileName = @"notes";
        //拼接文件夹路径
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
        //判断是否存在当天日期文件夹
        if (![fileManager fileExistsAtPath:filePath]) {
            //创建当天日期文件夹
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
       
        //归档文件名称为当天提醒时间，如：08/43
        NSString *docName = [self.note.creatTime stringByReplacingOccurrencesOfString:@":" withString:@"-"];
        //归档文件路径
        NSString *path = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arch",docName]];
        if ([NSKeyedArchiver archiveRootObject:self.note toFile:path]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - lazyLoading

-(YEXNote *)note
{
    if (!_note) {
        _note = [[YEXNote alloc] init];
    }
    return _note;
}

@end
