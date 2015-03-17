//
// CHOConcurrentOperation.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/15.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOConcurrentOperation.h"

@interface CHOConcurrentOperation ()

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@end

@implementation CHOConcurrentOperation

- (instancetype)init
{
    self = [super init];

    if(self) {
        self.isFinished = NO;
        self.isExecuting = NO;
    }

    return self;
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

#pragma mark - NSOperation
- (void)start
{
    NSLog(@"start:%@", self.name);

    if(self.cancelled) {
        // キャンセルされていれば、オペレーションを完了状態に移行する。
        self.isFinished = YES;

        return;
    }

    [self main];
}

- (BOOL)isAsynchronous
{
    return NO;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

#pragma mark - CHOOperation
- (void)didStartTask
{
    [super didStartTask];
    self.isExecuting = YES;
}

- (void)didFinishTask
{
    self.isExecuting = NO;
    self.isFinished = YES;
    [super didFinishTask];
}

@end