//
//  PDSDownloadTask.h
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/14.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

//ATS
//https://forums.developer.apple.com/thread/3544

static NSMutableArray *downloadTaskArray;

@interface PDSDownloadTask : NSObject

+ (NSMutableArray *)allDownloadTask;
+ (BOOL)isDownloadURLString:(NSString *)urlString;
+ (PDSDownloadTask *)startdDownloadTaskOfURLString:(NSString *)urlString;
+ (PDSDownloadTask *)findDownloadTaskOfURLString:(NSString *)urlString;

@property(nonatomic) double downloadProgress;
@property(nonatomic, strong) NSString *onlineURLString;
- (NSString *)localURLString;

@end
