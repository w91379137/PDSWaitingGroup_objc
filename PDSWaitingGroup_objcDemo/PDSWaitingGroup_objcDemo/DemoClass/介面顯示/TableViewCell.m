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

#pragma mark - Init
+ (instancetype)cellFromXib
{
    if ([[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"] == nil) {
        NSLog(@"不存在 xib : %@",NSStringFromClass([self class]));
        return nil;
    }
    
    id obj =
    [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                   owner:nil
                                 options:nil] lastObject];
    
    if (![obj isKindOfClass:self]) {
        NSLog(@"型態不合 xib : %@",NSStringFromClass([self class]));
        return nil;
    }
    return obj;
}

#pragma mark - Setter / Getter
- (void)setDataObject:(DataObject *)dataObject
{
    if (_dataObject == dataObject) {
        return;
    }
    
    if (_dataObject) {
        [self.dataObject removeSafeObserver:self
                                 forKeyPath:NSStringFromSelector(@selector(downloadProgress))];
    }
    
    _dataObject = dataObject;
    
    [self.dataObject addSafeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(downloadProgress))
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:currentContext];
    
    [self.dataObject addSafeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(status))
                             options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                             context:currentContext];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == currentContext) {
        if (object == self.dataObject) {
            if ([keyPath isEqualToString:@"downloadProgress"]) {
                self.valueLabel.text = [NSString stringWithFormat:@"%f",self.dataObject.downloadProgress];
            }
            else if ([keyPath isEqualToString:@"status"]){
                switch (self.dataObject.status) {
                    case DataObjectStatusNoFile:
                        self.statusLabel.text = @"無檔案";
                        break;
                    case DataObjectStatusDownloading:
                        self.statusLabel.text = @"下載中";
                        break;
                    case DataObjectStatusHadDownload:
                        self.statusLabel.text = @"已下載";
                        break;
                        
                    default:
                        break;
                }
                
                self.valueLabel.hidden = !(self.dataObject.status == DataObjectStatusDownloading);
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
