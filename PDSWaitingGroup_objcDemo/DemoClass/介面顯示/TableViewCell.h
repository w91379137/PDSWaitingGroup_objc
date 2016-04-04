//
//  TableViewCell.h
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataObject.h"

@interface TableViewCell : UITableViewCell

+ (instancetype)cellFromXib;
@property(nonatomic, strong) NSString *urlString;
- (void)startDownload;

@property(nonatomic, strong) IBOutlet UILabel *statusLabel;
@property(nonatomic, strong) IBOutlet UILabel *valueLabel;

@end
