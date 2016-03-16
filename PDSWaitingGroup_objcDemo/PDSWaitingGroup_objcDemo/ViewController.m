//
//  ViewController.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "DataObject.h"
#import "TableViewCell.h"

//Download Source
//https://blog.allenchou.cc/100mb-1000mb-download-test/

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadURLArray =
        @[];
        NSAssert(self.downloadURLArray.count != 0, @"請輸入一些下載網址");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainTableView.tableFooterView = nil;
}

#pragma mark - IBAction
- (IBAction)pushNext:(id)sender
{
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadURLArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cellFromXib];
    NSString *urlString = self.downloadURLArray[indexPath.row];
    DataObject *dataObject = [DataObject findDataObjectOfURLString:urlString];
    cell.dataObject = dataObject;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    DataObject *dataObject = cell.dataObject;
    [dataObject startdDownload];
}

@end
