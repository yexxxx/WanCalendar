//
//  YEXAddRmdTableViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXAddRmdTableViewController.h"

@interface YEXAddRmdTableViewController ()

@property(strong, nonatomic)NSArray<NSNumber *> *times;
@property(copy, nonatomic)transSeconds block;

@end

@implementation YEXAddRmdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.times = [NSArray arrayWithObjects:
                  [NSNumber numberWithInteger:0],
                  [NSNumber numberWithInteger:5*60],
                  [NSNumber numberWithInteger:15*60],
                  [NSNumber numberWithInteger:30*60],
                  [NSNumber numberWithInteger:60*60],
                  [NSNumber numberWithInteger:2*60*60],
                  [NSNumber numberWithInteger:24*60*60],
                  [NSNumber numberWithInteger:2*24*60*60],
                  [NSNumber numberWithInteger:7*24*60*60],
                  nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.times.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = textFont;
    cell.textLabel.text = [self textWithtimes:self.times[indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    typeof(self) weakSelf = self;
    NSNumber *secnods = self.times[indexPath.row];
    if (self.block) {
        self.block(secnods.integerValue,[weakSelf textWithtimes:secnods]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)transBlock:(transSeconds)Block {
    self.block = Block;
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
