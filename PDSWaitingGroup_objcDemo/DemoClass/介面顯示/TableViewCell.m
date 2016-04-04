//
//  TableViewCell.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "TableViewCell.h"
#import "DataObject.h"

static void *currentContext = &currentContext;
//http://nshipster.com/key-value-observing/
//http://stackoverflow.com/questions/20768745/what-does-it-mean-to-write-static-void-ptr-ptr-in-objective-c

@interface TableViewCell()

@property(nonatomic, weak) DataObject *dataObject;

@end

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

#pragma mark - IBAction
- (IBAction)startDownload
{
    [self.dataObject startdDownload];
}

#pragma mark - Setter / Getter
- (void)setUrlString:(NSString *)urlString
{
    _urlString = maybe(urlString, NSString);
    if (self.urlString)
        self.dataObject =
        [DataObject findDataObjectOfURLString:self.urlString];
}

- (void)setDataObject:(DataObject *)dataObject
{
    if (_dataObject == dataObject) return;
    _dataObject = dataObject;
    
    weakSelfMake(weakSelf);
    
    [self.dataObject addSafeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(downloadProgress))
                      UniqueModifyID:@"downloadProgress"
                         ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                             weakSelf.valueLabel.text =
                             [NSString stringWithFormat:@"%f",weakSelf.dataObject.downloadProgress];
                         }];
    
    [self.dataObject addSafeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(status))
                      UniqueModifyID:@"status"
                         ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                             
                             switch (weakSelf.dataObject.status) {
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
                             
                             weakSelf.valueLabel.hidden =
                             !(weakSelf.dataObject.status == DataObjectStatusDownloading);
                         }];
}

@end
