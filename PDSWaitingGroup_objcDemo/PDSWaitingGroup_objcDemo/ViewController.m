//
//  ViewController.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "PDSDownloadTask.h"
#import "TableViewCell.h"

//Download Source
//https://blog.allenchou.cc/100mb-1000mb-download-test/

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    _downloadArray =
    @[];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mainTableView.tableFooterView = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [[TableViewCell alloc] init];
    cell.backgroundColor = [UIColor orangeColor];
    
    NSString *urlString = _downloadArray[indexPath.row];
    
    if ([PDSDownloadTask isDownloadURLString:urlString]) {
        
        //已經下載
        cell.task = nil;
    }
    else {
        PDSDownloadTask *task = [PDSDownloadTask findDownloadTaskOfURLString:urlString];
        if (task) {
            //已經有其人啟動此下載
            cell.task = task;
        }
        else {
            //還沒開始下載
            cell.task = nil;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlString = _downloadArray[indexPath.row];
    
    if ([PDSDownloadTask isDownloadURLString:urlString]) {
        //已經下載
    }
    else {
        
        TableViewCell *cell = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        PDSDownloadTask *task = [PDSDownloadTask findDownloadTaskOfURLString:urlString];
        if (task) {
            
            //已經有其人啟動此下載
            cell.task = task;
        }
        else {
            
            //新啟動
            cell.task =
            [PDSDownloadTask startdDownloadTaskOfURLString:urlString];
        }
    }
}

@end
