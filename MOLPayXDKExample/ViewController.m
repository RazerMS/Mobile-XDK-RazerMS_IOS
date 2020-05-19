//
//  ViewController.m
//  MOLPayXDKExample
//
//  Created by Clement on 26/02/2016.
//  Copyright © 2016 MOLPay. All rights reserved.
//

#import "ViewController.h"
#import <MOLPayXDK/MOLPayLib.h>

@interface ViewController () <MOLPayLibDelegate>
{
    MOLPayLib *mp;
    BOOL isCloseButtonClick;
    BOOL isPaymentInstructionPresent;
}

@end

@implementation ViewController

- (IBAction)closemolpay:(id)sender
{
    // Closes MOLPay
    [mp closemolpay];
    
    isCloseButtonClick = YES;
}

- (IBAction)startmolpay:(id)sender
{
    // Default setting for Cash channel payment result conditions
    isPaymentInstructionPresent = NO;
    isCloseButtonClick = NO;
    
    // Setup payment details
    NSDictionary * paymentRequestDict = @{
                                          @"mp_amount": @"1.10", // Mandatory
                                          @"mp_username": @"xxxxxx", // Mandatory
                                          @"mp_password": @"xxxxxx", // Mandatory
                                          @"mp_merchant_ID": @"xxxxxx", // Mandatory
                                          @"mp_app_name": @"xxxxxx", // Mandatory
                                          @"mp_order_ID": @"", // Mandatory
                                          @"mp_currency": @"MYR", // Mandatory
                                          @"mp_country": @"MY", // Mandatory
                                          @"mp_verification_key": @"xxxxxx", // Mandatory
                                          @"mp_channel": @"multi", // Optional
                                          @"mp_bill_description": @"description", // Optional
                                          @"mp_bill_name": @"name", // Optional
                                          @"mp_bill_email": @"example@email.com", // Optional
                                          @"mp_bill_mobile": @"+601234556789", // Optional
                                          //@"mp_channel_editing": [NSNumber numberWithBool:NO], // Optional
                                          //@"mp_editing_enabled": [NSNumber numberWithBool:NO], // Optional
                                          //@"mp_dev_mode": [NSNumber numberWithBool:YES] // Optional, enable for online sandbox testing.
                                          
                                          //@"mp_transaction_id": @"", // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
                                          //@"mp_request_type": @"" // Optional, set 'Status' when performing a transactionRequest
                                          //@"mp_preferred_token": @"" // Optional, set the token id to nominate a preferred token as the default selection
                                          //@"mp_bin_lock": [NSArray arrayWithObjects:@"414170", @"414171", nil], // Optional for credit card BIN restrictions
                                          //@"mp_bin_lock_err_msg": @"Only UOB allowed" // Optional for credit card BIN restrictions
                                          //@"mp_is_escrow": @"" // Optional for escrow
                                          //@"mp_filter": @"", // Optional for debit card transactions only
                                          //@"mp_custom_css_url": [[NSBundle mainBundle] pathForResource:@"custom.css" ofType:nil], // Optional for custom UI
                                          //@"mp_is_recurring": [NSNumber numberWithBool:NO] // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf
                                          //@"mp_allowed_channels": [NSArray arrayWithObjects:@"credit", @"credit3", nil] // Optional for channels restriction
                                          //@"mp_sandbox_mode": [NSNumber numberWithBool:YES] // Optional for sandboxed development environment, set boolean value to enable.
                                          //@"mp_express_mode": [NSNumber numberWithBool:NO] // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
                                          //@"mp_advanced_email_validation_enabled": [NSNumber numberWithBool:YES] // Optional, enable this for extended email format validation based on W3C standards.
                                          //@"mp_advanced_phone_validation_enabled": [NSNumber numberWithBool:YES] // Optional, enable this for extended phone format validation based on Google i18n standards.
                                          //@"mp_bill_name_edit_disabled": [NSNumber numberWithBool:NO] // Optional, explicitly force disable billing name edit.
                                          //@"mp_bill_email_edit_disabled": [NSNumber numberWithBool:NO] // Optional, explicitly force disable billing email edit.
                                          //@"mp_bill_mobile_edit_disabled": [NSNumber numberWithBool:NO] // Optional, explicitly force disable billing mobile edit.
                                          //@"mp_bill_description_edit_disabled": [NSNumber numberWithBool:NO] // Optional, explicitly force disable billing description edit.
                                          //@"mp_language": @"EN" // Optional, EN, MS, VI, TH, FIL, MY, KM, ID, ZH.
                                          //@"mp_cash_waittime": @"48" // Optional, Cash channel payment request expiration duration in hour.
                                          //@"mp_non_3DS": [NSNumber numberWithBool:YES] // Optional, allow non-3ds on some credit card channels.
                                          //@"mp_card_list_disabled": [NSNumber numberWithBool:YES] // Optional, disable card list option.
                                          //@"mp_disabled_channels": [NSArray arrayWithObjects:@"credit", nil] // Optional for channels restriction
                                          };
    
    mp = [[MOLPayLib alloc] initWithDelegate:self andPaymentDetails:paymentRequestDict];
    mp.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(closemolpay:)];
    mp.navigationItem.hidesBackButton = YES;
    
    // Push method (This requires host navigation controller to be available at this point of runtime process,
    // refer AppDelegate.m for sample Navigation Controller implementations)
    //    [self.navigationController pushViewController:mp animated:YES];
    
    // Present method (Simple mode)
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mp];
    [self presentViewController:nc animated:NO completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pay now"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(startmolpay:)];
}

// MOLPayLibDelegates
- (void)transactionResult: (NSDictionary *)result
{
    // Payment status results returned here
    NSLog(@"transactionResult result = %@", result);
    
    // All success cash channel payments will display a payment instruction, we will let the user to close manually
    if ([[result objectForKey:@"pInstruction"] integerValue] == 1 && isPaymentInstructionPresent == NO && isCloseButtonClick == NO)
    {
        isPaymentInstructionPresent = YES;
    }
    else
    {
        // Push method
        //        [self.navigationController popViewControllerAnimated:NO];
        
        // Present method
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
