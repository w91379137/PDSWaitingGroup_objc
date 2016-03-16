//
//  DataObject.h
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/16.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DataObjectStatus) {
    DataObjectStatusNoFile,
    DataObjectStatusDownloading,
    DataObjectStatusHadDownload,
};

@interface DataObject : NSObject
/*
 將單一資料檔 升級成物件
 提供UI全部KVO資料
 */

+ (DataObject *)findDataObjectOfURLString:(NSString *)urlString;

@property(nonatomic) DataObjectStatus status;
@property(nonatomic) double downloadProgress;

@property(nonatomic, strong) NSString *onlineURLString;
- (NSString *)localURLString;
- (void)startdDownload;

@end
