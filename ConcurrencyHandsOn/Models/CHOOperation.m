//
// CHOOperation.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/15.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOOperation.h"
#import "CHOOperationConstant.h"

@interface CHOOperation ()

@end

@implementation CHOOperation

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];

    if(self) {
        self.name = info[@"name"];
        self.sleepTimeInterval = [(NSNumber *) info[@"sleepTimeInterval"] doubleValue];
        self.isDependentBeforeTask = [info[@"isDependentBeforeTask"] boolValue];
        self.queuePriorityString = info[@"queuePriority"];
    }

    return self;
}

#pragma mark - NSOperation
- (void)main
{
    NSLog(@"main:%@", self.name);

    // タスク開始処理実行
    [self didStartTask];

    // タスク実行
    [self execTask];

    // 完了処理実行
    [self didFinishTask];
}

#pragma mark - public
- (void)didStartTask
{
    NSDictionary *userInfo = @{ CHOOperationTextNotificationKey: self.name };

    [[NSNotificationCenter defaultCenter] postNotificationName:CHOOperationDidStartNotification object:self userInfo:userInfo];
    NSLog(@"didStart:%@", self.name);
}

- (void)execTask
{
    // スレッド番号を抽出
    NSString *threadString = [NSString stringWithFormat:@"%@", [NSThread currentThread]];
    NSString *tmpString = [threadString componentsSeparatedByString:@"{"][1];
    NSString *threadNumber = [tmpString componentsSeparatedByString:@","][0];
    NSString *number = [threadNumber componentsSeparatedByString:@" = "][1];

    NSString *text = [NSString stringWithFormat:@"%@:\nisMainThread:%d\nThread:%@", self.name, [NSThread isMainThread], number];
    NSDictionary *userInfo = @{ CHOOperationTextNotificationKey: text };

    [[NSNotificationCenter defaultCenter] postNotificationName:CHOOperationExecTaskNotification object:self userInfo:userInfo];
    NSLog(@"exec:%@", text);
    // スリープ
    [NSThread sleepForTimeInterval:self.sleepTimeInterval];
}

- (void)didFinishTask
{
    [self didChangeValueForKey:@"isFinished"];
    NSDictionary *userInfo = @{ CHOOperationTextNotificationKey: self.name };

    [[NSNotificationCenter defaultCenter] postNotificationName:CHOOperationDidFinishNotification object:self userInfo:userInfo];
    NSLog(@"didFinish:%@", self.name);
}

@end