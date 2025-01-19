//
//  LCSChooseAdIndexCollectionViewController.m
//  EmpowerDemo
//
//  Created by ByteDance on 2024/3/7.
//  Copyright © 2024 bytedance. All rights reserved.
//

#import "LCSChooseAdIndexCollectionViewController.h"
#import "LCSChooseAdIndexCollectionViewCell.h"

@interface LCSChooseData : NSObject

@property (nonatomic) NSInteger title;

@property (nonatomic) BOOL selected;

@end

@implementation LCSChooseData

@end

@interface LCSChooseAdIndexCollectionViewController ()

@property (nonatomic) NSMutableArray<LCSChooseData *> *data;

@end

@implementation LCSChooseAdIndexCollectionViewController

static NSString * const reuseIdentifier = @"LCSChooseAdIndexCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    if (@available(iOS 13.0, *)) {
        self.collectionView.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        // Fallback on earlier versions
    }
    
    // Register cell classes
    [self.collectionView registerClass:[LCSChooseAdIndexCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (NSMutableArray<LCSChooseData *> *)data {
    if (!_data) {
        _data = [NSMutableArray array];
        for (int i = 0; i < 120; i++) {
            LCSChooseData *d = [[LCSChooseData alloc] init];
            d.title = i;
            [_data addObject:d];
        }
    }
    return _data;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.selectBlock) {
        NSMutableArray *r = [NSMutableArray array];
        for (LCSChooseData *d in self.data) {
            if (d.selected) {
                [r addObject:@(d.title)];
            }
        }
        self.selectBlock([r copy]);
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCSChooseAdIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    LCSChooseData *d = [self.data objectAtIndex:indexPath.item];
    [cell setData:d.title selected:d.selected];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LCSChooseData *d = [self.data objectAtIndex:indexPath.item];
    d.selected = !d.selected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

@end
