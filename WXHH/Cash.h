//
//  Cash.h
//  PagingDemo
//
//  Created by Chen Weigang on 12-3-8.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    USD_100 = 0,
    USD_50  = 1,
    USD_20  = 2,
    USD_10  = 3
}CashType;

@interface Cash : UIImageView {
    int page; // 第幾頁
//    BOOL isFake;
    
    UIImageView *imgFake;
}
@property (nonatomic, assign, readonly) int value;
@property (nonatomic, assign, readonly) CashType type;  // 面值

- (id)initWithOrigin:(CGPoint)origin CashType:(CashType)type;

- (void)pickup;         // 掀開一個角
- (void)putdown;        // 掀開後，又放下了
- (void)page;           // 掀開後往下拖拽 放連續動畫

- (void)cash0;

- (void)resetType;

@end
