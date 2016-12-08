//
//  SearchResultTableView.h
//  SearchTable
//
//  Created by SJG on 16/12/5.
//  Copyright © 2016年 SJG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchResultClickCallBack)(NSString *select);
@interface SearchResultTableView : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *searchResultArray;
@property (nonatomic, copy) SearchResultClickCallBack selectCallBack;
@end
