//
//  SearchResultTableView.m
//  SearchTable
//
//  Created by SJG on 16/12/5.
//  Copyright © 2016年 SJG. All rights reserved.
//

#import "SearchResultTableView.h"

@interface SearchResultTableView ()
<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchResultTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    self.definesPresentationContext = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSString *string = [self.searchResultArray objectAtIndex:indexPath.row];
    NSArray *strings = [string componentsSeparatedByString:@"+"];
    cell.textLabel.text = strings.firstObject;
    cell.detailTextLabel.text = [@"+" stringByAppendingString:strings.lastObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.searchResultArray objectAtIndex:indexPath.row];
    if (self.selectCallBack) {
        self.selectCallBack(string);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


#pragma mark - private
- (void)setupTableView
{
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    // 约束同样必须置顶, 但是会导致搜索结果跑到搜索框下面, 所以手动偏移 tableview 内容
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}




@end
