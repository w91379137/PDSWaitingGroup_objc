//
//  ViewController.h
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *downloadURLArray;             //預計下載的所有URL 不管是否重複

@property(nonatomic, strong) IBOutlet UITableView *mainTableView;

@end
