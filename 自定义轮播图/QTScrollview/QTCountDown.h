//
//  QTCountDown.h
//  倒计时
//
//  Created by Maker on 16/7/5.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface QTCountDown : NSObject
///用NSDate日期倒计时
-(void)countDownWithStratDate:(NSDate *)startDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///用时间戳倒计时
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;

/// 每秒走一次，回调block
-(void)countDownWithTime:(NSInteger)number Block:(void (^)(void))PER_SECBlock;

/// 主动销毁定时器
-(void)destoryTimer;

/// <#Description#>
-(NSDate *)dateWithLongLong:(long long)longlongValue;
@end
