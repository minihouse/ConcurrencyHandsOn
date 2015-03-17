//
// CHOOperationListViewController.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/15.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOOperationListViewController.h"
#import "CHOOperationConstant.h"
#import "CHOOperationListTableViewCell.h"
#import "CHOConcurrentOperation.h"
#import "CHONonConcurrentOperation.h"
#import "CHOOperationQueueManager.h"

NSString *const CHOOperationListTableViewCellIndentifier = @"CHOOperationListTableViewCell";

@interface CHOOperationListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSDictionary *operationDictionary;
@property (nonatomic, strong) CHOOperationQueueManager *operationQueueManager;

@end

@implementation CHOOperationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupOperation];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // NotificationCenterを全て削除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 * #pragma mark - Navigation
 *
 * // In a storyboard-based application, you will often want to do a little preparation before navigation
 * - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *  // Get the new view controller using [segue destinationViewController].
 *  // Pass the selected object to the new view controller.
 * }
 */

#pragma mark - setup

- (void)setupTableView
{
    UINib *nib = [UINib nibWithNibName:@"CHOOperationListTableViewCell" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:CHOOperationListTableViewCellIndentifier];
}

- (void)setupOperation
{
    // NotiricationCenter登録
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(operationDidStart:)
                               name:CHOOperationDidStartNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(operationExecTask:)
                               name:CHOOperationExecTaskNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(operationDidFinish:)
                               name:CHOOperationDidFinishNotification
                             object:nil];

    self.operationQueueManager = [[CHOOperationQueueManager alloc] init];
    self.operationDictionary = self.operationQueueManager.operationDictionary;

    [self.operationQueueManager setupOperationQueueWithType:self.operationQueueType];
}

#pragma mark - private

- (void)addText:(NSString *)string
{
    NSString *currentString = self.textView.text;

    self.textView.text = [NSString stringWithFormat:@"%@\n%@", currentString, string];
}

- (NSArray *)operationsAtSection:(NSInteger)section
{
    switch(section) {
            case CHOOperationListTableSectionConcurrent:
        {
            // 非同期
            return self.operationQueueManager.concurrentOperations;
            break;
        }
            case CHOOperationListTableSectionNonConcurrent:
        {
            // 期
            return self.operationQueueManager.nonConcurrentOperations;
            break;
        }

            default:
        {
            return nil;
            break;
        }
    }
}

#pragma mark - NSNotificationCenter
- (void)operationDidStart:(NSNotification *)notification
{
    // テキスト追加
    NSString *text = [[notification userInfo] objectForKey:CHOOperationTextNotificationKey];

    // バックグラウンドスレッドで入ってくる可能性があるので、メインスレッドで実行
    [self performSelectorOnMainThread:@selector(addText:)
                           withObject:[NSString stringWithFormat:@"タスク開始：%@", text]
                        waitUntilDone:NO];
}

- (void)operationExecTask:(NSNotification *)notification
{
    // テキスト追加
    NSString *text = [[notification userInfo] objectForKey:CHOOperationTextNotificationKey];

    // バックグラウンドスレッドで入ってくる可能性があるので、メインスレッドで実行
    [self performSelectorOnMainThread:@selector(addText:)
                           withObject:[NSString stringWithFormat:@"タスク実行：%@", text]
                        waitUntilDone:NO];
}

- (void)operationDidFinish:(NSNotification *)notification
{
    // テキスト追加
    NSString *text = [[notification userInfo] objectForKey:CHOOperationTextNotificationKey];

    // バックグラウンドスレッドで入ってくる可能性があるので、メインスレッドで実行
    [self performSelectorOnMainThread:@selector(addText:)
                           withObject:[NSString stringWithFormat:@"タスク終了：%@", text]
                        waitUntilDone:NO];
}

#pragma mark - table view dataSrouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.operationDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *operations = [self operationsAtSection:section];

    if(operations) {
        return [operations count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHOOperationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOOperationListTableViewCellIndentifier];

    NSArray *operations = [self operationsAtSection:indexPath.section];

    if(operations) {
        CHOOperation *operation = operations[indexPath.row];

        cell.name.text = operation.name;
        cell.sleep.text = [NSString stringWithFormat:@"%.1f", operation.sleepTimeInterval];
        cell.dependent.text = operation.isDependentBeforeTask ? @"YES" : @"NO";
        cell.queuePriority.text = operation.queuePriorityString;
        NSLog(@"%f", operation.sleepTimeInterval);
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section) {
            case CHOOperationListTableSectionConcurrent:
        {
            return @"非同期";
            break;
        }
            case CHOOperationListTableSectionNonConcurrent:
        {
            return @"同期";
            break;
        }

            default:

            return @"";
    }
}

#pragma mark - table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 何もしない
}

@end