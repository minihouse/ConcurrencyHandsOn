//
// CHOHandsOnViewController.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/18.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOHandsOnViewController.h"
#import "CHOHandsOnOperation.h"
#import "CHOHandsOnCollectionViewCell.h"

static NSInteger OperationCount = 10; // NSOperationの数

@interface CHOHandsOnViewController ()

@property (nonatomic, strong) NSArray *operations;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation CHOHandsOnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // タスク実行
    [self execOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // タスクのキャンセル
    [self.queue cancelAllOperations];

    // KVO解除
    for(CHOHandsOnOperation *operation in self.operations) {
        [operation removeObserver:self forKeyPath:@"isExecuting"];
        [operation removeObserver:self forKeyPath:@"isFinished"];
    }
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

/*
 * タスク並列実行
 */
- (void)execOperations
{
    # warning 課題1-7 : NSOperationQueueにタスクを追加して並列実行せよ
}

#pragma mark - setter/getter

- (NSOperationQueue *)queue
{
    if(!_queue) {
        # warning 課題1-6 : マルチスレッド用NSOperationQueueを生成せよ

        # warning 課題2 : 最大並列数を2にせよ
    }

    return _queue;
}

/*
 * NSOperationのを複数生成する
 */
- (NSArray *)operations
{
    if(!_operations) {
        NSMutableArray *operations = [[NSMutableArray alloc] init];

        for(NSInteger i = 0; i < OperationCount; i++) {
            NSNumber *index = [NSNumber numberWithInteger:i];

            # warning 課題1-3 : NSOperationを生成し、配列operationsに追加せよ

            # warning 課題1-4 : CHOHandsOnOperationの"isExecuting"と"isFinished"をKVO登録せよ
        }

        _operations = [operations copy];
    }

    return _operations;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *index = (__bridge NSNumber *) context;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[index integerValue] inSection:0];
    CHOHandsOnCollectionViewCell *cell = (CHOHandsOnCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    CHOHandsOnOperation *operation = (CHOHandsOnOperation *) object;

    # warning 課題1-5 : isExecutingとisFinishedの更新時処理を実装せよ

    /*
     * ヒント
     * isExecuting = YESの場合 : [cell startLoading]を実行
     * isFinished = YESの場合 : [cell stopLoading]を実行
     * ここはバックグラウンドスレッドで入ってくるが、UIはメインスレッドで行う必要がある
     * performSelectorOnMainThreadメソッドを使うとメインスレッドで実行できる
     */
}

#pragma mark - collection view deleagete

#pragma mark - collection view dataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// セクション内のセル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.operations count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHOHandsOnCollectionViewCell *cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    [cell stopLoading];

    return cell;
}

@end