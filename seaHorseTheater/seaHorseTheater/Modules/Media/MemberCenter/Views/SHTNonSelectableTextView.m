//
//  SHTNonSelectableTextView.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 7/20/25.
//

#import "SHTNonSelectableTextView.h"

@implementation SHTNonSelectableTextView

// 禁止变成第一响应者（不弹出键盘/菜单）
- (BOOL)canBecomeFirstResponder {
    return NO;
}

// 禁止所有操作菜单项（复制、粘贴等）
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

// 禁止选中
- (BOOL)isSelectable {
    return NO;
}

@end
