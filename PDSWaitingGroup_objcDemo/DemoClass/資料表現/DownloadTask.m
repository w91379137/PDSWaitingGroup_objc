//
//  PDSDownloadTask.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "DownloadTask.h"
#import <AFNetworking/AFNetworking.h>
static NSMutableArray *downloadTaskArray;

@implementation DownloadTask

#pragma mark - Class Method
+ (NSMutableArray *)allDownloadTask
{
    if (!downloadTaskArray) downloadTaskArray = [NSMutableArray array];
    return downloadTaskArray;
}

+ (DownloadTask *)findDownloadTaskOfURLString:(NSString *)urlString
{
    NSArray * allURL = [self.allDownloadTask valueForKey:@"onlineURLString"];
    NSInteger index = [allURL indexOfObject:urlString];
    if (index != NSNotFound) return self.allDownloadTask[index];
    return nil;
}

#pragma mark -
- (void)startdDownload
{
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:self.onlineURLString]];
    
    NSURLSessionConfiguration *configuration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager =
    [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask =
    [manager downloadTaskWithRequest:request
                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.downloadProgress = downloadProgress.fractionCompleted;
                                });
                            }
                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                             return [NSURL fileURLWithPath:self.localURLString];
                         }
                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                       NSLog(@"下載完成");
                       [DownloadTask.allDownloadTask removeObject:self];
                   }];
    
    [DownloadTask.allDownloadTask addObject:self];
    [downloadTask resume];
}

@end
