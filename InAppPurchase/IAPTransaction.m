//
//  IAPTransaction.m
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import "IAPTransaction.h"
#import "IAPNetworking.h"

NSNotificationName const IAPTransactionCanNotMakePaymentsNotification = @"IAPCanNotMakePayments";// 没有内购权限
NSNotificationName const IAPTransactionProductEmptyNotification = @"IAPProductEmpty";// 商品为空
NSNotificationName const IAPTransactionStatePurchasingNotification = @"IAPStatePurchasing";// 正在交易
NSNotificationName const IAPTransactionStatePurchasedNotification = @"IAPStatePurchased";// 交易完成
NSNotificationName const IAPTransactionStateFailedNotification = @"IAPStateFailed";// 交易失败
NSNotificationName const IAPTransactionStateRestoredNotification = @"IAPStateRestored";// 已购买过A
NSNotificationName const IAPTransactionStateCancelledNotification = @"IAPStateCancelled";// 交易取消
NSNotificationName const IAPTransactionVerificationFailedNotification = @"IAPVerificationFailed";// App server 验证交易凭证失败

static IAPTransaction *_sharedTransaction;

@interface IAPTransaction()<SKPaymentTransactionObserver>

@end

@implementation IAPTransaction{
    
    dispatch_queue_t _IAP_Queue;
}

+ (IAPTransaction *)sharedTransaction {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTransaction = [self new];
    });
    return _sharedTransaction;
}

- (instancetype)init {
    if (self = [super init]) {
        _IAP_Queue  = dispatch_queue_create("iap.manager.pay.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - IAPTransaction protocol
//- (void)finishTransaction:(SKPaymentTransaction *)transaction complete:(dispatch_block_t)completedBlock {
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}

- (void)addTransactionObserver {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)removeTransactionObserver {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)purchaseWithProductId:(nonnull NSString *)productId {
    dispatch_async(_IAP_Queue, ^{
        
        if (![SKPaymentQueue canMakePayments]) { // 没有权限
            // 发送通知
            [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionCanNotMakePaymentsNotification object:nil];
            return;
        }
        
        if (!productId.length) {// 商品为空
            [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionProductEmptyNotification object:nil];
            return;
        }
        
        SKMutablePayment *payment = [[SKMutablePayment alloc] init];
        payment.productIdentifier = productId;
        payment.quantity = 1;// 购买一次
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    });
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing://正在交易
                [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionStatePurchasingNotification object:nil];
                break;
                
            case SKPaymentTransactionStatePurchased://交易完成
            {
                // 定位收据
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
                
                // 交给服务端验证收据
                [IAPNetworking sendReceiptToAPPServer:receipt success:^{// 验证成功
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionStatePurchasedNotification object:nil userInfo:@{@"receipt": receipt}];
                } failure:^{// 验证失败
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionVerificationFailedNotification object:nil];
                } responseFailure:^(NSString * _Nonnull msg) {// 网络错误
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionVerificationFailedNotification object:nil];
                } networkError:^{// 网络错误
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionVerificationFailedNotification object:nil];
                }];
                
            }
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
            {
                if(transaction.error.code != SKErrorPaymentCancelled) {
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionStateFailedNotification object:nil];
                } else {
                    [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionStateCancelledNotification object:nil];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [NSNotificationCenter.defaultCenter postNotificationName:IAPTransactionStateRestoredNotification object:nil];
            }
                break;
                
            default:
                
                break;
        }
    }
}

@end
