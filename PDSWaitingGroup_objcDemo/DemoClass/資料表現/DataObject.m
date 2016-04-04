//
//  DataObject.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/16.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "DataObject.h"

#import "PathManager.h"
#import "DownloadTask.h"
#import "PDSSafeKVO_objc.h"
static void *currentContextx = &currentContextx;
static NSMutableArray *allDataObjectArray;

@interface DataObject()

@property(nonatomic, weak) DownloadTask *task;

@end

@implementation DataObject

#pragma mark - Class Method
+ (NSMutableArray *)allDataObject
{
    if (!allDataObjectArray) allDataObjectArray = [NSMutableArray array];
    return allDataObjectArray;
}

+ (DataObject *)findDataObjectOfURLString:(NSString *)urlString
{
    DataObject *find = nil;
    for (DataObject *dataObject in self.allDataObject) {
        if ([dataObject.onlineURLString isEqualToString:urlString]) {
            find = dataObject;
            break;
        }
    }
    
    if (!find) {
        find = [[DataObject alloc] init];
        find.onlineURLString = urlString;
        [self.allDataObject addObject:find];
    }
    
    return find;
}

#pragma mark - Setter / Getter
- (void)setOnlineURLString:(NSString *)onlineURLString
{
    _onlineURLString = onlineURLString;
    if (self.onlineURLString) {
        self.task = [DownloadTask findDownloadTaskOfURLString:self.onlineURLString];
        [self renewStatus];
    }
}

- (void)setTask:(DownloadTask *)task
{
    if (_task == task) return;

    _task = task;
    if(task != nil) self.status = DataObjectStatusDownloading;
    
    weakSelfMake(weakSelf);
    [self.task addSafeObserver:self
                    forKeyPath:NSStringFromSelector(@selector(downloadProgress))
                UniqueModifyID:@"downloadProgress"
                   ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                       weakSelf.downloadProgress = weakSelf.task.downloadProgress;
                       if (weakSelf.downloadProgress >= 1) [weakSelf renewStatus];
                   }];
}

- (NSString *)localURLString
{
    if (self.onlineURLString) {
        return [PathManager targetFilePathFromURL:self.onlineURLString];
    }
    else {
        return nil;
    }
}

#pragma mark -
- (void)renewStatus
{
    DataObjectStatus status = DataObjectStatusNoFile;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.localURLString]) {
        status = DataObjectStatusHadDownload;
    }
    else if (self.task){
        status = DataObjectStatusDownloading;
    }
    if (self.status != status) {
        self.status = status;
    }
}

- (void)startdDownload
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.localURLString]) {
        NSLog(@"已下載");
        return;
    }
    
    if (self.task) {
        NSLog(@"下載中");
        return;
    }
    
    DownloadTask *task = [[DownloadTask alloc] init];
    self.task = task;
    task.onlineURLString = self.onlineURLString;
    task.localURLString = self.localURLString;
    [task startdDownload];
    
    [self renewStatus];
}

@end
