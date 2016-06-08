//
//  YEXNotesTableVC.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/26.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXNotesTableVC.h"
#import "YEXNoteViewController.h"
#import "YEXNote.h"

@interface YEXNotesTableVC ()

@property(nonatomic, strong)NSMutableArray <YEXNote *> *notes;
@property(nonatomic, strong)NSMutableArray <NSString *> *notePaths;

@end

@implementation YEXNotesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.title = @"备忘录";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor brownColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.notes removeAllObjects];
    //获取document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //获取fileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //文件夹名字为当天日期，如：2016-06-07
    NSString *fileName = @"notes";
    //拼接文件夹路径
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    //判断是否存在当天日期文件夹
    if (![fileManager fileExistsAtPath:filePath]) return;
    //遍历当前文件夹
    NSError *error = nil;
    NSArray *pathes = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    //解档文件
    [pathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *archivePath = [filePath stringByAppendingPathComponent:obj];
    
        [self.notes insertObject:[NSKeyedUnarchiver unarchiveObjectWithFile: archivePath] atIndex:0];
        [self.notePaths insertObject:archivePath atIndex:0];
    }];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyLoading

-(NSMutableArray *)notes
{
    if (!_notes) {
        _notes = [NSMutableArray array];
    }
    return _notes;
}

-(NSMutableArray *)notePaths
{
    if (!_notePaths) {
        _notePaths = [NSMutableArray array];
    }
    return _notePaths;
}

#pragma mark - target-action
-(void)leftButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightButtonClicked {
    YEXNoteViewController *noteVC = [[YEXNoteViewController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:noteVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.notes[indexPath.row].title;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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
    
    YEXNoteViewController *noteVC = [[YEXNoteViewController alloc] init];
    noteVC.note = self.notes[indexPath.row];
    noteVC.notePath = self.notePaths[indexPath.row];
    [self.navigationController pushViewController:noteVC animated:YES];
}




@end
