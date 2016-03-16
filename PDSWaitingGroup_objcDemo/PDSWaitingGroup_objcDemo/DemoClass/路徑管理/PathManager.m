//
//  PathManager.m
//  PDSWaitingGroup_objcDemo
//
//  Created by w91379137 on 2016/3/16.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PathManager.h"
#import "NSString+MD5.h"

@implementation PathManager

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

@end
