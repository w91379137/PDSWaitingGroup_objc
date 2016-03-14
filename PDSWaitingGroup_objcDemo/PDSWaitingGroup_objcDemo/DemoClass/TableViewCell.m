//
//  TableViewCell.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "TableViewCell.h"
#import "PDSSafeKVO_objc.h"
static void *currentContext = &currentContext;
//http://nshipster.com/key-value-observing/

@implementation TableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTask:(PDSDownloadTask *)task
{
    if (_task == task) {
        return;
    }
    
    if (_task) {
        [self.task removeSafeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(downloadProgress))];
    }
    
    _task = task;
    
    [self.task addSafeObserver:self
                    forKeyPath:NSStringFromSelector(@selector(downloadProgress))
                       options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                       context:currentContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == currentContext) {
        if (object == self.task) {
            self.textLabel.text = [NSString stringWithFormat:@"%f",self.task.downloadProgress];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
