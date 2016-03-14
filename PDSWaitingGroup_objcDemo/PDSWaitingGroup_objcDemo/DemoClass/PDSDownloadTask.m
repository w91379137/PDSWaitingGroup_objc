//
//  PDSDownloadTask.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSDownloadTask.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+MD5.h"

@implementation PDSDownloadTask

+ (NSMutableArray *)allDownloadTask
{
    if (!downloadTaskArray) {
        downloadTaskArray = [NSMutableArray array];
    }
    return downloadTaskArray;
}

+ (BOOL)isDownloadURLString:(NSString *)urlString
{
    if ([urlString isKindOfClass:[NSString class]]) {
        NSString *cachePath = [self targetFilePathFromURL:urlString];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager fileExistsAtPath:cachePath];
    }
    return NO;
}

+ (PDSDownloadTask *)startdDownloadTaskOfURLString:(NSString *)urlString
{
    PDSDownloadTask *task = [[PDSDownloadTask alloc] init];
    task.onlineURLString = urlString;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask *downloadTask =
    [manager downloadTaskWithRequest:request
                            progress:^(NSProgress * _Nonnull downloadProgress) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    task.downloadProgress = downloadProgress.fractionCompleted;
                                });
                            }
                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                return [NSURL fileURLWithPath:task.localURLString];
                            }
                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                       NSLog(@"下載完成");
                            }];
    [downloadTask resume];
    
    [self.allDownloadTask addObject:task];
    return task;
}

+ (PDSDownloadTask *)findDownloadTaskOfURLString:(NSString *)urlString
{
    NSArray * allURL = [self.allDownloadTask valueForKey:@"onlineURLString"];
    NSInteger index = [allURL indexOfObject:urlString];
    if (index != NSNotFound) {
        return self.allDownloadTask[index];
    }
    return nil;
}

#pragma mark - path
+ (NSString *)targetFilePathFromURL:(NSString *)keyString
{
    if ([keyString isKindOfClass:[NSString class]]) {
        
        NSString *md5Str = [NSString md5:keyString];
        NSString *cachePath = [[self cachesPath] stringByAppendingPathComponent:md5Str];
        
        cachePath =
        [cachePath stringByAppendingPathExtension:keyString.pathExtension];
        return cachePath;
    }
    return nil;
}

+ (NSString *)cachesPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
}

+ (void)createFileDir:(NSString *)dir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    BOOL isExist = [fileManager fileExistsAtPath:dir isDirectory:&isDir];
    
    if (isExist == NO || isDir == NO) {
        
        NSNumber *num = [NSNumber numberWithBool:YES];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:num, NSFileExtensionHidden, nil];
        
        BOOL createSuccess = [fileManager createDirectoryAtPath:dir
                                    withIntermediateDirectories:YES
                                                     attributes:attribs
                                                          error:nil];
        if (createSuccess == NO) {
            return;
        }
    }
}

#pragma mark - 
- (void)setDownloadProgress:(double)downloadProgress
{
    _downloadProgress = downloadProgress;
    NSLog(@"%f",downloadProgress);
}

- (NSString *)localURLString
{
    if (self.onlineURLString) {
        return [PDSDownloadTask targetFilePathFromURL:self.onlineURLString];
    }
    else {
        return nil;
    }
}

@end
