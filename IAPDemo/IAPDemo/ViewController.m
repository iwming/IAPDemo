//
//  ViewController.m
//  IAPDemo
//
//  Created by wangmin on 15-3-25.
//  Copyright (c) 2015年 wangmin. All rights reserved.
//

#import "ViewController.h"

#import "IAPPurchase.h"

@interface ViewController ()
<IAPPurchaseDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    IAPPurchase *myIAPPurchase;
    BOOL isPurchased;

    NSArray *productIdsArray;
    NSArray *productsArray;
}
@property (retain, nonatomic) IBOutlet UIButton *buyBtn;
@property (retain, nonatomic) IBOutlet UIPickerView *selectedPickView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myIAPPurchase = [[IAPPurchase alloc] init];
    myIAPPurchase.delegate = self;
    
    isPurchased = NO;
    
//    productIdsArray = [@[@"com.ag.if.ws.100mc",@"com.ag.if.ws.350mc",@"com.ag.if.ws.750mc"] retain];
    productIdsArray = [@[@"com.kskj.Test_one"] retain];
    
    
    self.selectedPickView.dataSource = self;
    self.selectedPickView.delegate = self;
    
//    [self.selectedPickView setAlpha:0];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showBuyList:(id)sender {
    
   self.buyBtn.enabled = NO;
   BOOL enable = [myIAPPurchase requestProduct:productIdsArray];

    
   if(!enable){
     self.title  = @"Purchase Disable in Settings";
    }

}
- (IBAction)restorePurchase:(id)sender {
    
    // Restore a customer's previous non-consumable or subscription In-App Purchase.
    // Required if a user reinstalled app on same device or another device.
    
    // Call restore method.
    if (![myIAPPurchase restorePurchase])
    {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
        [settingsAlert release];
    }

    
}

#pragma mark  IAPPurchaseDelegate
//获取到列表
- (void)showPurchaseProductList:(NSArray *)products
{
    
     self.buyBtn.enabled = YES;
    
    if(!products){
    //没有有效的product id
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
        [unavailAlert release];
        return;
    }
    productsArray = [products copy];
    [self.selectedPickView reloadAllComponents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedPickView.alpha = 1;
    });
}

//购买成功 回调
-(void) successfulPurchase:(IAPPurchase *)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");

    if (!isPurchased)
    {

        isPurchased = YES;

        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Your purhase was successful and the Game Levels Pack is now unlocked for your enjoyment!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
        [updatedAlert release];
    }
    
}

//购买失败
-(void) failedPurchase:(IAPPurchase *)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}

//不能完成Restore
-(void) incompleteRestore:(IAPPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    [restoreAlert release];
}
//restore 失败
-(void) failedRestore:(IAPPurchase *)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}


#pragma mark UIPickView Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    SKProduct *product = productsArray[row];
    
    return [NSString stringWithFormat:@"%@ price:%@",product.localizedTitle,product.price];

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [myIAPPurchase selectedProduct: productsArray[row]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedPickView.alpha = 0;
    });

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return productsArray.count;

}

- (void)dealloc {
    [_selectedPickView release];
    [productIdsArray release];
    [productsArray release];
    [_buyBtn release];
    [super dealloc];
}
@end
