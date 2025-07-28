//
//  SHTOthersCell.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2025/7/25.
//

#import "SHTOthersCell.h"
#import "SHTOthersCommonCell.h"
#import "SHTMineModel.h"
#import <Masonry/Masonry.h>

@interface SHTOthersCell()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; // 列表

@end

@implementation SHTOthersCell

- (void)addSubviews {
    [self.contentView addSubview:self.tableView];
}

- (void)addLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(10.0);
        make.top.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-10.0);
        make.bottom.equalTo(self.contentView).offset(-20.0);
    }];
}

#pragma mark - actions

- (void)setDatasArray:(NSMutableArray *)datasArray {
    _datasArray = datasArray;
    [self.tableView reloadData];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 90.0;
        _tableView.backgroundColor = SHT_BACK_COLOR_DARK;
        [_tableView registerClass:[SHTOthersCommonCell class] forCellReuseIdentifier:@"SHTOthersCommonCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 12.0;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHTMineModel *model = self.datasArray[indexPath.row];
    SHTOthersCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHTOthersCommonCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHTMineModel *model = self.datasArray[indexPath.row];
    NSString *id = model.uniqueIdentifier;
    if ([id isEqualToString:@"czjl"]) {
        // 充值记录
        
    } else if ([id isEqualToString:@"lxwm"]) {
        // 联系我们

    } else if ([id isEqualToString:@"jyfk"]) {
        // 建议反馈
        
    } else if ([id isEqualToString:@"yhxy"]) {
        // 用户协议
        
    } else if ([id isEqualToString:@"yszc"]) {
        // 隐私政策
        
    }
}

@end
