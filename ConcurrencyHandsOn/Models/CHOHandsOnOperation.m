//
// CHOHandsOnOperation.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/18.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOHandsOnOperation.h"

@interface CHOHandsOnOperation ()

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@end

@implementation CHOHandsOnOperation
- (instancetype)init
{
    self = [super init];

    if(self) {
        _isExecuting = NO;
        _isFinished = YES;
    }

    return self;
}

#pragma mark - NSOperation
- (void)main
{
    # warning 課題1-1 : タスクとしてスリープ処理を実装せよ
    // スリープ
    [NSThread sleepForTimeInterval:2.0];
}

- (void)start
{
    # warning 課題1-2 : タスクの開始時の状態変更、タスク実行、タスク終了時の状態変更を実装せよ
    self.isExecuting = YES;
    [self main];
    self.isFinished = YES;
    self.isExecuting = NO;
}

#pragma mark - NSObject
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if([key isEqualToString:@"isExecuting"] ||
       [key isEqualToString:@"isFinished"]) {
        return YES;
    }

    return [super automaticallyNotifiesObserversForKey:key];
}

@end