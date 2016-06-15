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

- (void)startReadFile:(NSString *)file page:(NSString *)page startTime:(NSTimeInterval)startTime;

- (void)endReadFile:(NSString *)file page:(NSString *)page endTime:(NSTimeInterval)endTime;

@end
