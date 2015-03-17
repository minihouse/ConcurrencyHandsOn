//
// CHOHandsOnCollectionViewCell.m
// ConcurrencyHandsOn
//
// Created by 小屋敷 圭史 on 2015/03/18.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CHOHandsOnCollectionViewCell.h"

@implementation CHOHandsOnCollectionViewCell

- (void)startLoading
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)stopLoading
{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}

@end