//
//  ReadTimeCount.m
//  ReadCount
//
//  Created by wangmingquan on 15/6/16.
//  Copyright © 2016年 wangmingquan. All rights reserved.
//

#import "ReadTimeCount.h"

#define kTimerFile @"ReadTimerFile.plist"

@interface ReadTimeCount ()

@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSTimer *timer;

@end

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

#pragma mark - lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - public
- (void)showReadFile:(NSString *)file page:(NSString *)page
{
    if ([self.dic allKeys].count == 0) {
        self.dic = [NSMutableDictionary dictionary];
        [self.dic setObject:file forKey:@"filename"];
        [self.dic setObject:@"yangshanli" forKey:@"reader"];
        NSTimeInterval inter = [[NSDate date] timeIntervalSince1970];
        NSString *t = [NSString stringWithFormat:@"%f", inter];
        [self.dic setObject:t forKey:@"time"];
    }
    NSString *currentFile = [self.dic objectForKey:@"currentFile"];
    NSString *currentPage = [self.dic objectForKey:@"currentPage"];
    NSDate *startDate = [self.dic objectForKey:@"startInterVal"];
    if (currentFile.length > 0 && currentPage.length > 0 && startDate != nil) {
        [self hideReadFile:currentFile page:currentPage];
    }
    NSDate *date = [NSDate date];
    [self.dic setObject:date forKey:@"startInterVal"];
    [self.dic setObject:page forKey:@"currentPage"];
    [self.dic setObject:file forKey:@"currentFile"];
}

- (void)hideReadFile:(NSString *)file page:(NSString *)page
{
    NSString *currentFile = [self.dic objectForKey:@"currentFile"];
    NSString *currentPage = [self.dic objectForKey:@"currentPage"];
    NSDate *startDate = [self.dic objectForKey:@"startInterVal"];
    NSDate *endDate = [NSDate date];
    // 是否是当前的文件 上次记录的是当前页
    if ([currentFile isEqualToString:file] && [page isEqualToString:currentPage]) {
        NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
        if (interval < 3) {//小于3秒就不记录
            [self.dic setObject:@"" forKey:@"currentFile"];
            [self.dic setObject:@"" forKey:@"currentPage"];
            [self.dic setObject:@"" forKey:@"startInterVal"];
            return;
        }
        // 先找看该页是否有保存的数据
        NSMutableArray *rows = [self.dic objectForKey:@"rows"];
        if (rows.count == 0) {
            // 没有 则可以直接设置进去
            rows = [NSMutableArray array];
            NSString *time = [NSString stringWithFormat:@"%f", interval];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:time forKey:page];
            [rows addObject:dic];
            [self.dic setObject:rows forKey:@"rows"];
            NSLog(@"之前没有该页数据 %@, 设置进去 当前row中的数据 %@", page, rows);
            [self.dic setObject:@"" forKey:@"currentFile"];
            [self.dic setObject:@"" forKey:@"currentPage"];
            [self.dic setObject:@"" forKey:@"startInterVal"];
            return;
        } else {
            int i = 0;
            for (; i < rows.count; i++) {
                NSMutableDictionary *dic = [rows objectAtIndex:i];
                NSString *key = [dic allKeys] > 0 ? [[dic allKeys]objectAtIndex:0] : @"-1";
                if ([key isEqualToString:page]) {
                    NSString *value = [dic objectForKey:key];
                    NSTimeInterval total = interval+[value floatValue];
                    [dic setObject:[NSString stringWithFormat:@"%f", total] forKey:page];
                    
                    [self.dic setObject:rows forKey:@"rows"];
                    NSLog(@"之前有该页数据 %@ 上次看了 %@秒, 这一次看了 %f秒, 设置进去 当前row中的数据 %@", page, value, interval, rows);
                    [self.dic setObject:@"" forKey:@"currentFile"];
                    [self.dic setObject:@"" forKey:@"currentPage"];
                    [self.dic setObject:@"" forKey:@"startInterVal"];
                    return;
                }
            }
            if (i == rows.count) {
                NSString *time = [NSString stringWithFormat:@"%f", interval];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:time forKey:page];
                [rows addObject:dic];
                [self.dic setObject:rows forKey:@"rows"];
                NSLog(@"rows %@中有数据 但是没有该页 %@ 数据", rows, page);
                [self.dic setObject:@"" forKey:@"currentFile"];
                [self.dic setObject:@"" forKey:@"currentPage"];
                [self.dic setObject:@"" forKey:@"startInterVal"];
                return;
            }
        }
    }
    NSLog(@"设置失败，file %@ page %@, currentfile %@, currentpage %@, startdate %@, enddate %@", file, page, currentFile, currentPage, startDate, endDate);
}

- (void)saveReadFileInfo:(NSString *)file
{
    NSString *filename = [self.dic objectForKey:@"filename"];
    NSArray *rows = [self.dic objectForKey:@"rows"];
    if (rows.count > 0) {
        if ([file isEqualToString:filename]) {
            [self _saveReadCountToLocal];
            NSLog(@"save file %@ 成功", file);
            return;
        }
    }
    NSLog(@"save file %@ 失败", file);
}

#pragma mark - private
- (void)_saveReadCountToLocal
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *filepath  = [NSString stringWithFormat:@"%@/%@", cachesDir, kTimerFile];
    NSMutableArray *ar = [NSMutableArray array];
    if ([fileManager fileExistsAtPath:filepath]) {
        ar = [NSMutableArray arrayWithContentsOfFile:filepath];
    }
    [ar addObject:self.dic];
    [ar writeToFile:filepath atomically:YES];
    self.dic = [NSMutableDictionary dictionary];
    [self uploadFileData:nil];
}

- (void)uploadFileData:(id)info
{
    NSLog(@"上传");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *filepath  = [NSString stringWithFormat:@"%@/%@", cachesDir, kTimerFile];
    // 上传的数据
    NSMutableArray *ar = [NSMutableArray arrayWithContentsOfFile:filepath];
    if (ar.count > 0) {
        NSDictionary *dic = [ar objectAtIndex:0];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSURLSession *session = [NSURLSession sharedSession];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hih6.com/index.php?r=api"]];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"POST"];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval:20];
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            s = [NSString stringWithFormat:@"data=%@",s];
            NSData *dataa = [s dataUsingEncoding:NSUTF8StringEncoding];
            NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:dataa completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    // 删除刚刚的数据
                    [fileManager removeItemAtPath:filepath error:nil];
                    // 定时器关闭
                    [self.timer invalidate]; self.timer = nil;
                    NSLog(@"上传成功%@", string);
                }else{
                    [self startTimer];
                    NSLog(@"上传失败");
                }
            }];
            [uploadTask resume];
        }
    }
}

- (void)startTimer
{
    if (self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(uploadFileData:) userInfo:nil repeats:YES];
        [self.timer fire];
    } else {
        [self.timer fire];
    }
}

@end
