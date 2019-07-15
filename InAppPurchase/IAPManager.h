//
//  IAPManager.h
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IAPCodeType) {
    
    IAPCodeTypeCanNotMakePayment, // 用户禁止应用内付费购买
    IAPCodeTypeTransactionStateRestored, // 该订单已完成
    IAPCodeTypeTransactionStatePurchasing, // 正在购买ing
    IAPCodeTypeTransactionStateFailed, // 交易失败
    IAPCodeTypeCancel, // 用户取消交易
    IAPCodeTypeBuyFailed, // 购买失败，请重试
    IAPCodeTypeEmptyGoods, // 商品为空
    IAPCodeTypeNetworkError, // 网络异常
    IAPCodeTypeAppServiceVerificationFailed,// 服务端验证失败。 交易验证失败，请重启应用，再次验证
    IAPCodeTypeSucceed, // 两个阶段都完成了，交易成功
};


@protocol IAPManagerDelegate <NSObject>

- (void)IAPTansactionResultCode:(IAPCodeType)codeType error:(NSString *)errorString;

@end

@protocol IAPCustomPurchase <NSObject>

/**
 购买商品
 是从服务端请求下来的
 @param productId 商品ID app申请的
 */
- (void)buyGoodsWithProductId:(NSString *)productId;
@end



@interface IAPManager : NSObject

@property (nonatomic, class, readonly, nonnull) IAPManager *sharedManager;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;
+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;
@property (nonatomic, weak) id <IAPManagerDelegate> delegate;
@end


@interface IAPManager (IAPManager)<IAPCustomPurchase>

@end
NS_ASSUME_NONNULL_END
