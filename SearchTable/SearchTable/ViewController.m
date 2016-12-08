//
//  ViewController.m
//  SearchTable
//
//  Created by SJG on 16/12/5.
//  Copyright © 2016年 SJG. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultTableView.h"

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource,
UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic, strong) UISearchController    *searchController;

@property (nonatomic, strong) NSMutableDictionary   *dataSource;
@property (nonatomic, strong) NSMutableArray        *searchResults;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialize];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize
{
    /**
     注意事项:
     1. 约束时不可手动设置偏移64 + self.automaticallyAdjustsScrollViewInsets = NO; 进行约束
     原因: 会导致搜索 hidesNavigationBarDuringPresentation = YES 时, tableView 有偏移
     */
    [self setupTableView];
    
    [[UINavigationBar appearance] setAlpha:1];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTranslucent:NO];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchResults removeAllObjects];
    for (NSInteger i = 0; i < self.keys.count; i ++) {
        NSArray *values = [self.dataSource objectForKey:self.keys[i]];
        for (NSInteger j = 0 ; j < values.count; j++) {
            NSString *string = values[j];
            if ([string containsString:searchText]) {
                [self.searchResults addObject:string];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchController.searchBar.text = @"";
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchController.searchBar setShowsCancelButton:YES animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    SearchResultTableView *resultController = (SearchResultTableView *)searchController.searchResultsController;
    resultController.searchResultArray = self.searchResults;
    [resultController.tableView reloadData];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active &&
        self.searchController.searchBar.text.length)
    {
        return 1;
    } else {
        return [self.dataSource allKeys].count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active && self.searchController.searchBar.text.length) {
        return self.searchResults.count;
    } else {
        NSArray *sectionData = [self.dataSource objectForKey:self.keys[section]];
        return sectionData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSString *string = nil;
    if (self.searchController.active && self.searchController.searchBar.text.length) {
        string = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        NSString *key = self.keys[indexPath.section];
        NSArray *sectionArray = [self.dataSource objectForKey:key];
        string = [sectionArray objectAtIndex:indexPath.row];
    }
    
    NSArray *strings = [string componentsSeparatedByString:@"+"];
    cell.textLabel.text = strings.firstObject;
    cell.detailTextLabel.text = [@"+" stringByAppendingString:strings.lastObject];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.keys objectAtIndex:section];
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.textLabel.text = key;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active && self.searchController.searchBar.text.length) {
        return 0;
    } else {
        return 30;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active && self.searchController.searchBar.text.length) {
        return nil;
    } else {
        return self.keys;
    }
}

#pragma mark - action

#pragma mark - private

- (void)setupTableView
{
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = self.keys.count;
    self.tableView.sectionIndexColor = [UIColor blueColor];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableHeaderView.frame = CGRectMake(0,
                                                      0,
                                                      [UIScreen mainScreen].bounds.size.width,
                                                      44);
    self.tableView.tableHeaderView.bounds = CGRectMake(0,
                                                       0,
                                                       [UIScreen mainScreen].bounds.size.width,
                                                       44);
    
}


#pragma mark - lazyload
- (UISearchController *)searchController
{
    if (!_searchController) {
        SearchResultTableView *result = [[SearchResultTableView alloc] init];
        result.selectCallBack = ^(NSString *select){
            self.title = [select componentsSeparatedByString:@"+"].firstObject;
            [self.searchController.searchBar endEditing:YES];
        };
        _searchController = [[UISearchController alloc] initWithSearchResultsController:result];
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];

        
    }
    return _searchController;
}

- (NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        NSString *smssdkBundlePath = [[NSBundle mainBundle] pathForResource:@"SMSSDKUI"
                                                                     ofType:@"bundle"];
        NSBundle *smssdkBundle = [NSBundle bundleWithPath:smssdkBundlePath];
        NSString *countryPath = [smssdkBundle pathForResource:@"country"
                                                       ofType:@"plist"];
        NSDictionary *countrys = [NSDictionary dictionaryWithContentsOfFile:countryPath];
        _dataSource = [countrys mutableCopy];
    }
    return _dataSource;
}
- (NSArray *)keys
{
    if (!_keys) {
        _keys = [self.dataSource.allKeys sortedArrayUsingSelector:@selector(compare:)];
    }
    return _keys;
}

- (NSMutableArray *)searchResults
{
    if (!_searchResults) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}


@end
