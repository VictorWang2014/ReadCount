//
//  ReadTimeCount.h
//  ReadCount
//
//  Created by wangmingquan on 15/6/16.
//  Copyright © 2016年 wangmingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ReadManager [ReadTimeCount shareInstance]

@interface ReadTimeCount : NSObject

+ (ReadTimeCount *)shareInstance;

- (void)showReadFile:(NSString *)file page:(NSString *)page;

- (void)hideReadFile:(NSString *)file page:(NSString *)page;

- (void)saveReadFileInfo:(NSString *)file;

@end
