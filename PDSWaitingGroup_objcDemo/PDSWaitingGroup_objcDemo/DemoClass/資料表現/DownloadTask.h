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

@interface DownloadTask : NSObject
/*
 僅是下載進程表現
 */

+ (DownloadTask *)findDownloadTaskOfURLString:(NSString *)urlString;

@property(nonatomic) double downloadProgress;
@property(nonatomic, strong) NSString *onlineURLString;
@property(nonatomic, strong) NSString *localURLString;
- (void)startdDownload;

@end
