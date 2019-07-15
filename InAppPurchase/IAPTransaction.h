//
//  IAPTransaction.h
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const IAPTransactionCanNotMakePaymentsNotification;// 没有内购权限
FOUNDATION_EXPORT NSNotificationName const IAPTransactionProductEmptyNotification;// 商品为空
FOUNDATION_EXPORT NSNotificationName const IAPTransactionStatePurchasingNotification;// 正在交易
FOUNDATION_EXPORT NSNotificationName const IAPTransactionStatePurchasedNotification;// 交易完成
FOUNDATION_EXPORT NSNotificationName const IAPTransactionStateFailedNotification;// 交易失败
FOUNDATION_EXPORT NSNotificationName const IAPTransactionStateRestoredNotification;// 已购买过
FOUNDATION_EXPORT NSNotificationName const IAPTransactionStateCancelledNotification;// 交易取消
FOUNDATION_EXPORT NSNotificationName const IAPTransactionVerificationFailedNotification;// APP服务端验证交易失败

@protocol IAPTransaction <NSObject>
/**
 添加观察者
 */
- (void)addTransactionObserver;
/**
 移除观察者
 */
- (void)removeTransactionObserver;

/**
 购买内购产品
 @param productId 产品ID
 */
- (void)purchaseWithProductId:(NSString *)productId;
@end

@interface IAPTransaction : NSObject<IAPTransaction>

@property (nonatomic, class, readonly, nonnull) IAPTransaction *sharedTransaction;

@end

NS_ASSUME_NONNULL_END
