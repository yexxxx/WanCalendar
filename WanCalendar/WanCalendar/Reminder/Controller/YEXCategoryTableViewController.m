//
//  YEXCategoryTableViewController.m
//  WanCalendar
//
//  Created by 叶希焰 on 16/5/2.
//  Copyright © 2016年 yex. All rights reserved.
//

#import "YEXCategoryTableViewController.h"
#import "YEXCategoryCell.h"

@interface YEXCategoryTableViewController ()

@property(strong, nonatomic) NSArray <NSString *>* categorys;
@property(copy, nonatomic)transCategoryBlock block;

@end

@implementation YEXCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[YEXCategoryCell class] forCellReuseIdentifier:NSStringFromClass([YEXCategoryCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.categorys = [[NSArray alloc] initWithObjects:@"家庭",@"宠物",@"购物",@"缴费",@"聚会",@"旅游",@"情人",@"工作", nil];
   
                         
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor *)colorWithCategory:(NSString *)category {
    if ([category isEqualToString:@"家庭"]) {
        return [UIColor cyanColor];
    }else if ([category isEqualToString:@"宠物"]) {
        return [UIColor orangeColor];
    }else if ([category isEqualToString:@"购物"]) {
        return [UIColor redColor];
    }
    else if ([category isEqualToString:@"缴费"]) {
        return [UIColor greenColor];
    }
    else if ([category isEqualToString:@"聚会"]) {
        return [UIColor yellowColor];
    }
    else if ([category isEqualToString:@"旅游"]) {
        return [UIColor yellowColor];
    }
    else if ([category isEqualToString:@"情人"]) {
        return [UIColor cyanColor];
    }
    else if ([category isEqualToString:@"工作"]) {
        return [UIColor purpleColor];
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categorys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YEXCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YEXCategoryCell class]) forIndexPath:indexPath];
    cell.title =self.categorys[indexPath.row];
    cell.roundColor = [self colorWithCategory:self.categorys[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSString *str = self.categorys[indexPath.row];
    if (self.block) {
        self.block(str,[weakSelf colorWithCategory:str]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)transBlock:(transCategoryBlock)block {
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
