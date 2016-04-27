//
//  IAPPurchase.h
//  IAPDemo
//
//  Created by wangmin on 15-3-25.
//  Copyright (c) 2015年 wangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol IAPPurchaseDelegate;


@interface IAPPurchase : NSObject


@property(assign) id<IAPPurchaseDelegate> delegate;


@property (nonatomic,retain) SKProduct *validProduct;



-(BOOL) requestProduct:(NSArray *)productIdsArray;
-(BOOL) purchaseProduct:(SKProduct*)requestedProduct;
-(BOOL) restorePurchase;

-(void) selectedProduct:(SKProduct *)product;

@end

@protocol IAPPurchaseDelegate <NSObject>

@optional


-(void) showPurchaseProductList:(NSArray *)products;

-(void) requestedProduct:(IAPPurchase *)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription;

-(void) successfulPurchase:(IAPPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt;

-(void) failedPurchase:(IAPPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage;

-(void) incompleteRestore:(IAPPurchase*)ebp;

-(void) failedRestore:(IAPPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage;


@end
