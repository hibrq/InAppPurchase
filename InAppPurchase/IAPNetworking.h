//
//  IAPNetworking.h
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPNetworking : NSObject
+ (void)sendReceiptToAPPServer:(NSString *)receipt
                       success:(dispatch_block_t)successBlock
                       failure:(dispatch_block_t)failureBlock
               responseFailure:(void(^)(NSString * msg))responseFailureBlock
                  networkError:(dispatch_block_t)newworkErrorBlock;
@end

NS_ASSUME_NONNULL_END
