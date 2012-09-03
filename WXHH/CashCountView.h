//
//  CashCountView.h
//  PagingDemo
//
//  Created by Chen Weigang on 12-3-8.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CashCountViewDelegate;

@interface CashCountView : UIView  {

    NSMutableArray *arrCashs;
    UIButton *btnTouch;
    
    int totalCash;
}

@property (nonatomic, assign) int indexCash;
@property (nonatomic, assign) id<CashCountViewDelegate> delegate;

- (void)reset;

- (id)initWithFrame:(CGRect)frame number:(int)number;

- (int)getTotalValue;
@end

@protocol CashCountViewDelegate
- (void)cashCountDidEnd;
- (void)cashCountFrameDidEnd;
- (void)cashCountDidStop;
@end
