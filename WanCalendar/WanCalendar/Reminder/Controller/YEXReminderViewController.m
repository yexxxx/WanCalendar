//
//  YEXReminderViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/4/28.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXReminderViewController.h"
#import "YEXUnflodTransiation.h"
#import "YEXTimePickerViewController.h"
#import "YEXCategoryTableViewController.h"
#import "YEXAddRmdTableViewController.h"
#import "YEXReminder.h"

@interface YEXReminderViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *beginTimeView;
@property (weak, nonatomic) IBOutlet UIView *endTimeView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *reminderView;

@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (weak, nonatomic) IBOutlet UITextField *locationView;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (strong, nonatomic) YEXUnflodTransiation *unflodTransiation;


@end

@implementation YEXReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.title = @"编辑提醒事项";
    self.titleView.delegate = self;
    self.locationView.delegate = self;
    self.reminder = self.reminder;
    if (!self.reminder) {
        self.reminder = [[YEXReminder alloc] init];
        self.navigationItem.title = @"添加提醒";
        self.deleteButton.hidden = YES;
    }

    //custom transition
    self.unflodTransiation = [[YEXUnflodTransiation alloc] init];
    
    
    //leftBarButton
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             bk_initWithTitle:@"取消"
                                             style:UIBarButtonItemStyleDone
                                            handler:^(id sender) {
                                                 if (weakSelf.remindePath) {
                                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                                 }else {
                                                     [weakSelf dismissViewControllerAnimated:YES completion:nil];}
    }];
    self.navigationItem.leftBarButtonItem.tintColor = goldColor;
    
    //rightBarButton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              bk_initWithTitle:@"添加"
                                              style:UIBarButtonItemStyleDone
                                              handler:^(id sender) {
                                                  [self archiveReminder:weakSelf.reminder];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = goldColor;
    
    
    //beginTimeTapGesture
    UITapGestureRecognizer *beginTimeTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        YEXTimePickerViewController *vc = [[YEXTimePickerViewController alloc] init];
        vc.currentDate = self.currentDate;
        vc.transitioningDelegate = weakSelf.unflodTransiation;
        [vc transDate:^(NSDate *date) {
            NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
            dateFormer.dateFormat = @"HH:mm";
            weakSelf.beginTimeLabel.text = [dateFormer stringFromDate:date];
            dateFormer.dateFormat = @"yyyy-MM-dd HH:mm";
            weakSelf.reminder.beginDate = [dateFormer stringFromDate:date];
        }];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [self.beginTimeView addGestureRecognizer:beginTimeTap];
    
    //endTimeTapGesture
    UITapGestureRecognizer *endTimeTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        YEXTimePickerViewController *vc = [[YEXTimePickerViewController alloc] init];
        vc.currentDate = self.currentDate;
        vc.transitioningDelegate = weakSelf.unflodTransiation;
        [vc transDate:^(NSDate *date) {
            NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
            dateFormer.dateFormat = @"HH:mm";
            weakSelf.endTimeLabel.text = [dateFormer stringFromDate:date];
            dateFormer.dateFormat = @"yyyy-MM-dd HH:mm";
            weakSelf.reminder.endDate = [dateFormer stringFromDate:date];
        }];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [self.endTimeView addGestureRecognizer:endTimeTap];
    
    //categoryTapGesture
    UITapGestureRecognizer *categoryTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        YEXCategoryTableViewController *vc = [[YEXCategoryTableViewController alloc] init];
        vc.transitioningDelegate = weakSelf.unflodTransiation;
        [vc transBlock:^(NSString *category, UIColor *color) {
            weakSelf.categoryLabel.text = category;
            weakSelf.categoryLabel.textColor = color;
            weakSelf.reminder.category = category;
        }];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [self.categoryView addGestureRecognizer:categoryTap];
    
    //reminderTapGesture
    UITapGestureRecognizer *reminderTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        YEXAddRmdTableViewController *vc = [[YEXAddRmdTableViewController alloc] init];
        vc.transitioningDelegate = weakSelf.unflodTransiation;
        [vc transBlock:^(NSInteger seconds, NSString *text) {
            self.reminderLabel.text = text;
            weakSelf.reminder.remindTime = [NSString stringWithFormat:@"%ld",seconds];
        }];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
    [self.reminderView addGestureRecognizer:reminderTap];
    
    
    
}

-(void)setReminder:(YEXReminder *)reminder {
    _reminder = reminder;
    self.titleView.text = reminder.title;
    self.locationView.text = reminder.location;
    self.beginTimeLabel.text = [reminder.beginDate componentsSeparatedByString:@" "][1];
    self.endTimeLabel.text = [reminder.endDate componentsSeparatedByString:@" "][1];
    self.categoryLabel.text = reminder.category;
    self.categoryLabel.textColor = [reminder lineColor];
    if (!reminder.remindTime || [reminder.remindTime isEqualToString:@""]) return;
    self.reminderLabel.text = [self textWithtimes:[NSNumber numberWithInteger:reminder.remindTime.integerValue]];
}

-(NSString *)textWithtimes:(NSNumber *)times {
    if (times.integerValue == 0) {
        return @"事件发生时";
    }else if (times.integerValue == 5*60) {
        return @"5分钟前";
    }else if (times.integerValue == 15*60) {
        return @"15分钟前";
    }else if (times.integerValue == 30*60) {
        return @"30分钟前";
    }else if (times.integerValue == 60*60) {
        return @"1小时前";
    }else if (times.integerValue == 2*60*60) {
        return @"2小时前";
    }else if (times.integerValue == 24*60*60) {
        return @"1天前";
    }else if (times.integerValue == 2*24*60*60) {
        return @"2天前";
    }else if (times.integerValue == 7*24*60*60) {
        return @"1周前";
    }
    return nil;
}
- (IBAction)deleteButtonClidked:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？"message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error = nil;
            if (![fileManager removeItemAtPath:weakSelf.remindePath error:&error]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
                alert.title = @"删除失败！";
                UIAlertAction* confimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                [alert addAction:confimAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];

            }else {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
            }
                                                              
        }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"%@",self.categoryView);
    }
    return self;
}


-(void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isCompleted {
    if ([self.reminder.title isEqualToString:@""] || !self.reminder.title) {
        return NO;
    }else if ([self.reminder.beginDate isEqualToString:@""] || !self.reminder.beginDate) {
        return NO;
    }
    else if ([self.reminder.endDate isEqualToString:@""] || !self.reminder.endDate) {
        return NO;
    }
    else if ([self.reminder.category isEqualToString:@""] || !self.reminder.category) {
        return NO;
    }
    else if ([self.reminder.remindTime isEqualToString:@""] || !self.reminder.remindTime) {
        return NO;
    }
    return YES;
}

- (void)archiveReminder:(YEXReminder *)reminder {
    typeof(self) weakSelf = self;
    if ([weakSelf isCompleted]) {
        NSDateFormatter *former = [[NSDateFormatter alloc] init];
        former.dateFormat = @"yyyy-MM-dd HH:mm";
       NSComparisonResult result= [[former dateFromString:reminder.beginDate] compare:[former dateFromString:reminder.endDate]];
        if (!(result == NSOrderedAscending)) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
            alert.title = @"请输入有效时间！";
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [weakSelf presentViewController:alert animated:YES completion:nil];
            return;
        }
        if (weakSelf.remindePath) {
            if ([NSKeyedArchiver archiveRootObject:reminder toFile:self.remindePath]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else {
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
                alert.title = @"添加失败！";
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
        }else {
            
            //获取document路径
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            //获取fileManager
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //文件夹名字为当天日期，如：2016-06-07
            NSString *fileName = [reminder.beginDate componentsSeparatedByString:@" "][0];
            //拼接文件夹路径
            NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
            //判断是否存在当天日期文件夹
            if (![fileManager fileExistsAtPath:filePath]) {
                //创建当天日期文件夹
                [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
            }
            NSDateFormatter *dateFormer = [[NSDateFormatter alloc] init];
            dateFormer.dateFormat = @"yyyy-MM-dd HH-mm-ss";
            //归档文件名称为当天提醒时间，如：08/43
            NSString *docName = [dateFormer stringFromDate:[NSDate date]];;
            //归档文件路径
            NSString *path = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arch",docName]];
            //归档文件
            if ([NSKeyedArchiver archiveRootObject:reminder toFile:path]) {
                if (weakSelf.remindePath) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
                alert.title = @"添加失败！";
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
        }

    }else{
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        alert.title = @"请输入完整信息！";
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //titleView.tag == 100
    if (textField.tag == 100) {
        self.reminder.title = textField.text;
    }else {
        self.reminder.location = textField.text;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
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
