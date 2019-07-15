//
//  ViewController.m
//  IAPDemo
//
//  Created by bianrongqiang on 7/12/18.
//  Copyright © 2018 bianrongqiang. All rights reserved.
//

#import "ViewController.h"
#import "IAPManager.h"
@interface ViewController ()<IAPManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [IAPManager.sharedManager buyGoodsWithProductId:@"........"];
    IAPManager.sharedManager.delegate = self;
}

- (void)IAPTansactionResultCode:(IAPCodeType)codeType error:(NSString *)errorString {
    switch (codeType) {
        case IAPCodeTypeTransactionStatePurchasing:
            break;
        case IAPCodeTypeTransactionStateFailed:
            break;
        case IAPCodeTypeTransactionStateRestored:
            break;
        case IAPCodeTypeNetworkError:
            break;
        case IAPCodeTypeAppServiceVerificationFailed:
            break;
        case IAPCodeTypeSucceed:
            break;
        case IAPCodeTypeCanNotMakePayment:
            break;
        default:
            break;
    }
}
@end
