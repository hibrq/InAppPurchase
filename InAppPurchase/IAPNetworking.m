//
//  IAPNetworking.m
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import "IAPNetworking.h"

@implementation IAPNetworking

+ (void)sendReceiptToAPPServer:(nonnull NSString *)receipt
                       success:(dispatch_block_t)successBlock
                       failure:(dispatch_block_t)failureBlock
               responseFailure:(void(^)(NSString * msg))responseFailureBlock
                  networkError:(dispatch_block_t)newworkErrorBlock {
    
    if (!receipt) {
        return;
    }
    
}

@end
