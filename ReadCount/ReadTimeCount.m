//
//  ReadTimeCount.m
//  ReadCount
//
//  Created by wangmingquan on 15/6/16.
//  Copyright © 2016年 wangmingquan. All rights reserved.
//

#import "ReadTimeCount.h"

@implementation ReadTimeCount

+ (ReadTimeCount *)shareInstance
{
    static ReadTimeCount *share = nil;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        share = [[ReadTimeCount alloc] init];
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showReadFile:(NSString *)file page:(NSString *)page
{
    
}

- (void)hideReadFile:(NSString *)file page:(NSString *)page
{
    
}

@end
