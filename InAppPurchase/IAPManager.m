//
//  IAPManager.m
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import "IAPManager.h"
#import "IAPTransaction.h"

static IAPManager *_sharedManager;

@implementation IAPManager

- (void)dealloc{
    [IAPTransaction.sharedTransaction removeTransactionObserver];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+ (IAPManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
    });
    return _sharedManager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self addNotificationObserver];
        
        /***
         内购支付两个阶段：
         1.app直接向苹果服务器请求商品，支付阶段；
         2.苹果服务器返回凭证，app向公司服务器发送验证，公司再向苹果服务器验证阶段；
         */
        [IAPTransaction.sharedTransaction addTransactionObserver];
    }
    return self;
}

- (void)addNotificationObserver {
    
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionProductEmptyNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeEmptyGoods error:@"商品为空"];
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionCanNotMakePaymentsNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeCanNotMakePayment error:@"用户禁止应用内付费购买"];
    }];
    
    
    // 已购买过
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionStateRestoredNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeTransactionStateRestored error:@"已购买"];
    }];
    // 交易失败
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionStateFailedNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeTransactionStateFailed error:@"交易失败"];
    }];
    // 交易成功
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionStatePurchasedNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeSucceed error:@"交易成功"];
    }];
    // 正在交易
    [NSNotificationCenter.defaultCenter addObserverForName:IAPTransactionStatePurchasingNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self requestResultCode:IAPCodeTypeTransactionStatePurchasing error:@"正在交易中..."];
    }];
}

- (void)requestResultCode:(IAPCodeType)codeType error:(NSString *)errorString {
    if (self.delegate && [self.delegate respondsToSelector:@selector(IAPTansactionResultCode:error:)]) {
        [self.delegate IAPTansactionResultCode:codeType error:errorString];
    }
}
@end

@implementation IAPManager (IAPManager)

- (void)buyGoodsWithProductId:(NSString *)productId{
    [IAPTransaction.sharedTransaction purchaseWithProductId:productId];
}

@end
