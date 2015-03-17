//
// CHOTopViewController.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/15.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOTopViewController.h"
#import "CHOOperationListViewController.h"
#import "CHOOperationQueueManager.h"
#import "CHOHandsOnViewController.h"

@interface CHOTopViewController ()

@end

@implementation CHOTopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CHOOperationQueueTypeMainThread"]) {
        // メインスレッドで実行するタイプ
        CHOOperationListViewController *nextViewController = [segue destinationViewController];

        nextViewController.title = [self cellLabelTextByCell:sender];
        nextViewController.operationQueueType = CHOOperationQueueTypeMainThread;
    } else if([[segue identifier] isEqualToString:@"CHOOperationQueueTypeMultiThread"]) {
        // バックグラウンドスレッドで実行するタイプ
        CHOOperationListViewController *nextViewController = [segue destinationViewController];

        nextViewController.title = [self cellLabelTextByCell:sender];
        nextViewController.operationQueueType = CHOOperationQueueTypeMultiThread;
    } else if([[segue identifier] isEqualToString:@"CHOOperationQueueTypeMultiThreadUseMaxCount"]) {
        // バックグラウンドスレッドで実行するタイプ(ただし、スレッド数はひとつ)
        CHOOperationListViewController *nextViewController = [segue destinationViewController];

        nextViewController.title = [self cellLabelTextByCell:sender];
        nextViewController.operationQueueType = CHOOperationQueueTypeMultiThreadUseMaxCount;
    } else if([[segue identifier] isEqualToString:@"CHOOperationQueueTypeMultiThreadUseDependency"]) {
        // バックグラウンドスレッドで実行するタイプ(依存関係あり)
        CHOOperationListViewController *nextViewController = [segue destinationViewController];

        nextViewController.title = [self cellLabelTextByCell:sender];
        nextViewController.operationQueueType = CHOOperationQueueTypeMultiThreadUseDependency;
    } else if([[segue identifier] isEqualToString:@"CHOOperationQueueTypeMultiThreadUseQueuePriority"]) {
        // バックグラウンドスレッドで実行するタイプ(優先度あり)
        CHOOperationListViewController *nextViewController = [segue destinationViewController];

        nextViewController.title = [self cellLabelTextByCell:sender];
        nextViewController.operationQueueType = CHOOperationQueueTypeMultiThreadUseQueuePriority;
    }
}

- (NSString *)cellLabelTextByCell:(UITableViewCell *)cell
{
    NSArray *subViews = [cell.contentView subviews];

    for(UIView *subView in subViews) {
        if([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *) subView;

            return label.text;
        }
    }

    return @"";
}

@end