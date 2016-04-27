//
//  IAPPurchase.m
//  IAPDemo
//
//  Created by wangmin on 15-3-25.
//  Copyright (c) 2015年 wangmin. All rights reserved.
//

#import "IAPPurchase.h"

@interface IAPPurchase ()
<SKPaymentTransactionObserver,SKProductsRequestDelegate>


@end

@implementation IAPPurchase

@synthesize delegate,validProduct;


- (BOOL)requestProduct:(NSArray *)productIdsArray
{
    if(productIdsArray.count){
        
        if([SKPaymentQueue canMakePayments]){
            //支持 in-app purchase
            NSLog(@"IAP enable");
            SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdsArray]];
            productRequest.delegate = self;
            [productRequest start];
            [productRequest release];
            
            return YES;
        }else{
            
            NSLog(@"IAP disable");
            
            return NO;
        }
    }else{
    
        NSLog(@"productIdsArray is empty");
        
        return NO;
    }
    
}

-(BOOL) purchaseProduct:(SKProduct*)requestedProduct
{
    if (requestedProduct != nil) {
        
        NSLog(@"IAPPurchase purchaseProduct: %@", requestedProduct.productIdentifier);
        
        if ([SKPaymentQueue canMakePayments]) {
            // Yes, In-App Purchase is enabled on this device.
            // Proceed to purchase In-App Purchase item.
            
            // Assign a Product ID to a new payment request.
            SKPayment *paymentRequest = [SKPayment paymentWithProduct:requestedProduct];
            
            // Assign an observer to monitor the transaction status.
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            
            // Request a purchase of the product.
            [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
            
            return YES;
            
        } else {
            // Notify user that In-App Purchase is Disabled.
            
            NSLog(@"IAPPurchase purchaseProduct: IAP Disabled");
            
            return NO;
        }
        
    } else {
        
        NSLog(@"IAPPurchase purchaseProduct: SKProduct = NIL");
        
        return NO;
    }
}

-(BOOL) restorePurchase
{
    NSLog(@"IAPPurchase restorePurchase");
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to restore purchases.
        // Assign an observer to monitor the transaction status.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        // Request to restore previous purchases.
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        
        return YES;
        
    } else {
        // Notify user that In-App Purchase is Disabled.
        return NO;
    }
}


-(void) selectedProduct:(SKProduct *)product
{
    
    self.validProduct = product;
    [self purchaseProduct:product];

}

#pragma mark SKProductsRequestDelegate Methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.validProduct = nil;
    
    int count = [response.products count];
    if(count > 0){
     //做扩展 让用户点击
//        self.validProduct = [response.products objectAtIndex:0];
        [delegate showPurchaseProductList:response.products];
        
    }else{
    
        NSLog(@"无效的productid %@",response.invalidProductIdentifiers);
         [delegate showPurchaseProductList:nil];
    }

}

#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                // Item is still in the process of being purchased
                break;
                
            case SKPaymentTransactionStatePurchased:
                // Item was successfully purchased!
                
                // Return transaction data. App should provide user with purchased product.
                
                [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:transaction.transactionReceipt];
            
                
                // After customer has successfully received purchased content,
                // remove the finished transaction from the payment queue.
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                // Verified that user has already paid for this item.
                // Ideal for restoring item across all devices of this customer.
                
                // Return transaction data. App should provide user with purchased product.
                
                [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:transaction.transactionReceipt];
                
                // After customer has restored purchased content on this device,
                // remove the finished transaction from the payment queue.
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                // Purchase was either cancelled by user or an error occurred.
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    // A transaction error occurred, so notify user.
                    
                    [delegate failedPurchase:self error:transaction.error.code message:transaction.error.localizedDescription];
                }
                // Finished transactions should be removed from the payment queue.
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
        }
    }
}

// Called when one or more transactions have been removed from the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"IAPPurchase removedTransactions");
    
    // Release the transaction observer since transaction is finished/removed.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// Called when SKPaymentQueue has finished sending restored transactions.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
    NSLog(@"IAPPurchase paymentQueueRestoreCompletedTransactionsFinished");
    
    if ([queue.transactions count] == 0) {
        // Queue does not include any transactions, so either user has not yet made a purchase
        // or the user's prior purchase is unavailable, so notify app (and user) accordingly.
        
        NSLog(@"IAPPurchase restore queue.transactions count == 0");
        
        // Release the transaction observer since no prior transactions were found.
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        
        [delegate incompleteRestore:self];
        
    } else {
        // Queue does contain one or more transactions, so return transaction data.
        // App should provide user with purchased product.
        
        NSLog(@"IAPPurchase restore queue.transactions available");
        
        for(SKPaymentTransaction *transaction in queue.transactions) {
            
            NSLog(@"IAPPurchase restore queue.transactions - transaction data found");
            
            [delegate successfulPurchase:self identifier:transaction.payment.productIdentifier receipt:transaction.transactionReceipt];
        }
    }
}

// Called if an error occurred while restoring transactions.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // Restore was cancelled or an error occurred, so notify user.
    
    NSLog(@"IAPPurchase restoreCompletedTransactionsFailedWithError");
    
    [delegate failedRestore:self error:error.code message:error.localizedDescription];
}





@end
