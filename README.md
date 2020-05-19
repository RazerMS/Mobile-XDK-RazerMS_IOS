<!--
# license: Copyright © 2011-2019 MOLPay Sdn Bhd. All Rights Reserved. 
-->

# rms-mobile-xdk-ios

<img src="https://user-images.githubusercontent.com/38641542/74424311-a9d64000-4e8c-11ea-8d80-d811cfe66972.jpg">

This is the complete and functional Razer Merchant Services iOS payment module that is ready to be implemented into Xcode application project as a MOLPayXDK framework. An example application project (MOLPayXDKExample.xcodeproj) is provided for MOLPayXDK framework integration reference.

这是一个完整和实用的 Razer Merchant Services iOS 支付模块，可以实现到 Xcode 以作为一个 MOLPayXDK 框架。在此提供了一个示例应用程序项目（MOLPayXDKExample.xcodeproj）以作为 MOLPayXDK 框架整合的参考。

## Recommended configurations

    - Xcode version: 9 ++
    
    - Minimum target version: iOS 8

## Installation

### CocoaPods

CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate RMS XDK into your Xcode project using CocoaPods, specify it in your Podfile:

    Step 1 - pod 'rms-mobile-xdk-cocoapods', '~> 3.28.0'
    Step 2a - Create bridging header if using Swift.
    Step 2b - Insert #import <MOLPayXDK/MOLPayLib.h> to bridging header.


### Manually For Objective-C
    
    Step 1 - Drag and drop MOLPayXDK.bundle and MOLPayXDK.framework into the application project folder to perform all imports. Please copy both files into the project.
    
    Step 2 - Add #import <MOLPayXDK/MOLPayLib.h>
    
    Step 3 - Add <MOLPayLibDelegate> to @interface
    
    Step 4 - Add -(void)transactionResult:(NSDictionary *)result for all delegate callbacks
    
    Step 5 - Add 'App Transport Security Settings > Allow Arbitrary Loads > YES' to the application project info.plist
    
    Step 6 - Add 'NSPhotoLibraryUsageDescription' > 'Payment images' to the application project info.plist

    Step 7 - Add 'NSPhotoLibraryAddUsageDescription' > 'Payment images' to the application project info.plist

### Manually For Swift
    
    Step 1 - Drag and drop MOLPayXDK.bundle and MOLPayXDK.framework into the application project folder to perform all imports. Please copy both files into the project.
    
    Step 2 - Create a bridging header file for MOLPay XDK Obj-c framework.
    Then add the bridging header file to the Swift Compiler under Objective-C Bridging Header. (Refer https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)
    
    Step 3 - Add #import <MOLPayXDK/MOLPayLib.h> to the last line of the bridging header file.
    
    Step 4 - Add MOLPayLibDelegate to the view controller class declaration
    
    Step 5 - Add func transactionResult(_ result: [AnyHashable: Any]!) for all delegate callbacks
    
    Step 6 - Add 'App Transport Security Settings > Allow Arbitrary Loads > YES' to the application project info.plist
    
    Step 7 - Add 'NSPhotoLibraryUsageDescription' > 'Payment images' to the application project info.plist

    Step 8 - Add 'NSPhotoLibraryAddUsageDescription' > 'Payment images' to the application project info.plist

## Prepare the Payment detail object

### For Objective-C

    NSDictionary * paymentRequestDict = @{
        // Optional, REQUIRED when use online Sandbox environment and account credentials.
        @"mp_dev_mode": [NSNumber numberWithBool:NO],
    
        // Mandatory String. Values obtained from MOLPay.
        @"mp_username": @"username",
        @"mp_password": @"password",
        @"mp_merchant_ID": @"merchantid",
        @"mp_app_name": @"appname",
        @"mp_verification_key": @"vkey123",
    
        // Mandatory String. Payment values.
        @"mp_amount": @"1.10", // Minimum 1.01
        @"mp_order_ID": @"orderid123",
        @"mp_currency": @"MYR",
        @"mp_country": @"MY",
        
        // Optional, but required payment values. User input will be required when values not passed.
        @"mp_channel": @"multi", // Use 'multi' for all available channels option. For individual channel seletion, please refer to https://github.com/RazerMS/rms-mobile-xdk-examples/blob/master/channel_list.tsv.
        @"mp_bill_description": @"billdesc",
        @"mp_bill_name": @"billname",
        @"mp_bill_email": @"email@domain.com",
        @"mp_bill_mobile": @"+1234567",
    
        // Optional, allow channel selection. 
        @"mp_channel_editing": [NSNumber numberWithBool:NO],
    
        // Optional, allow billing information editing.
        @"mp_editing_enabled": [NSNumber numberWithBool:NO],
    
        // Optional, for Escrow.
        @"mp_is_escrow": @"0", // Put "1" to enable escrow
    
        // Optional, for credit card BIN restrictions and campaigns.
        @"mp_bin_lock": [NSArray arrayWithObjects:@"414170", @"414171", nil],
    
        // Optional, for mp_bin_lock alert error.
        @"mp_bin_lock_err_msg": @"Only UOB allowed",
        
        // WARNING! FOR TRANSACTION QUERY USE ONLY, DO NOT USE THIS ON PAYMENT PROCESS.
        // Optional, provide a valid cash channel transaction id here will display a payment instruction screen. Required if mp_request_type is 'Receipt'.
        @"mp_transaction_id": @"",
        // Optional, use 'Receipt' for Cash channels, and 'Status' for transaction status query.
        @"mp_request_type": @"",
    
        // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file can be obtained at https://github.com/RazerMS/rms-mobile-xdk-examples/blob/master/custom.css.
        @"mp_custom_css_url": [[NSBundle mainBundle] pathForResource:@"custom.css" ofType:nil],
    
        // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only.
        @"mp_preferred_token": @"",
    
        // Optional, credit card transaction type, set "AUTH" to authorize the transaction.
        @"mp_tcctype": @"",
    
        // Optional, required valid credit card channel, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf. 
        @"mp_is_recurring": [NSNumber numberWithBool:NO],
    
        // Optional, show nominated channels.
        @"mp_allowed_channels": [NSArray arrayWithObjects:@"credit", @"credit3", nil],
    
        // Optional, simulate offline payment, set boolean value to enable. 
        @"mp_sandbox_mode": [NSNumber numberWithBool:YES],
    
        // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
        @"mp_express_mode": [NSNumber numberWithBool:YES],
    
        // Optional, extended email format validation based on W3C standards.
        @"mp_advanced_email_validation_enabled": [NSNumber numberWithBool:YES],
    
        // Optional, extended phone format validation based on Google i18n standards.
        @"mp_advanced_phone_validation_enabled": [NSNumber numberWithBool:YES],
    
        // Optional, explicitly force disable user input.
        @"mp_bill_name_edit_disabled": [NSNumber numberWithBool:YES],
        @"mp_bill_email_edit_disabled": [NSNumber numberWithBool:YES],
        @"mp_bill_mobile_edit_disabled": [NSNumber numberWithBool:YES],
        @"mp_bill_description_edit_disabled": [NSNumber numberWithBool:YES],
    
        // Optional, EN, MS, VI, TH, FIL, MY, KM, ID, ZH.
        @"mp_language": @"EN",
    
        // Optional, Cash channel payment request expiration duration in hour.
        @"mp_cash_waittime": @"48",
        
        // Optional, allow bypass of 3DS on some credit card channels.
        @"mp_non_3DS": [NSNumber numberWithBool:YES],
    
        // Optional, disable card list option.
        @"mp_card_list_disabled": [NSArray arrayWithObjects:@"credit", nil],
    
        // Optional for channels restriction, this option has less priority than mp_allowed_channels.
        @"mp_disabled_channels": [NSArray arrayWithObjects:@"credit", nil]
    };

### For Swift

    let paymentRequestDict: [String:Any] = [
        // Optional, REQUIRED when use online Sandbox environment and account credentials.
        "mp_dev_mode": NSNumber.init(booleanLiteral:false),
    
        // Mandatory String. Values obtained from MOLPay.
        "mp_username": "username",
        "mp_password": "password",
        "mp_merchant_ID": "merchantid",
        "mp_app_name": "appname",
        "mp_verification_key": "vkey123",
    
        // Mandatory String. Payment values.
        "mp_amount": "1.10", // Minimum 1.01
        "mp_order_ID": "orderid123",
        "mp_currency": "MYR",
        "mp_country": "MY",
        
        // Optional, but required payment values. User input will be required when values not passed.
        "mp_channel": "multi", // Use 'multi' for all available channels option. For individual channel seletion, please refer to https://github.com/RazerMS/rms-mobile-xdk-examples/blob/master/channel_list.tsv.
        "mp_bill_description": "billdesc",
        "mp_bill_name": "billname",
        "mp_bill_email": "email@domain.com",
        "mp_bill_mobile": "+1234567",
    
        // Optional, allow channel selection. 
        "mp_channel_editing": NSNumber.init(booleanLiteral:false),
    
        // Optional, allow billing information editing.
        "mp_editing_enabled": NSNumber.init(booleanLiteral:false),
    
        // Optional, for Escrow.
        "mp_is_escrow": "0", // Put "1" to enable escrow
    
        // Optional, for credit card BIN restrictions and campaigns.
        "mp_bin_lock": ["414170", "414171"],    
    
        // Optional, for mp_bin_lock alert error.
        "mp_bin_lock_err_msg": "Only UOB allowed",
        
        // WARNING! FOR TRANSACTION QUERY USE ONLY, DO NOT USE THIS ON PAYMENT PROCESS.
        // Optional, provide a valid cash channel transaction id here will display a payment instruction screen. Required if mp_request_type is 'Receipt'.
        "mp_transaction_id": "",
        // Optional, use 'Receipt' for Cash channels, and 'Status' for transaction status query.
        "mp_request_type": "",
    
        // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file can be obtained at https://github.com/RazerMS/rms-mobile-xdk-examples/blob/master/custom.css.
        "mp_custom_css_url": Bundle.main.path(forResource: "custom.css", ofType: nil)!,
    
        // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only.
        "mp_preferred_token": "",
    
        // Optional, credit card transaction type, set "AUTH" to authorize the transaction.
        "mp_tcctype": "",
    
        // Optional, required valid credit card channel, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf. 
        "mp_is_recurring": NSNumber.init(booleanLiteral:false),
    
        // Optional, show nominated channels.
        "mp_allowed_channels": ["credit", "credit3"],
    
        // Optional, simulate offline payment, set boolean value to enable. 
        "mp_sandbox_mode": NSNumber.init(booleanLiteral:true),
    
        // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
        "mp_express_mode": NSNumber.init(booleanLiteral:true),
    
        // Optional, extended email format validation based on W3C standards.
        "mp_advanced_email_validation_enabled": NSNumber.init(booleanLiteral:true),
    
        // Optional, extended phone format validation based on Google i18n standards.
        "mp_advanced_phone_validation_enabled": NSNumber.init(booleanLiteral:true),
    
        // Optional, explicitly force disable user input.
        "mp_bill_name_edit_disabled": NSNumber.init(booleanLiteral:true),
        "mp_bill_email_edit_disabled": NSNumber.init(booleanLiteral:true),
        "mp_bill_mobile_edit_disabled": NSNumber.init(booleanLiteral:true),
        "mp_bill_description_edit_disabled": NSNumber.init(booleanLiteral:true),
    
        // Optional, EN, MS, VI, TH, FIL, MY, KM, ID, ZH.
        "mp_language": "EN",
    
        // Optional, Cash channel payment request expiration duration in hour.
        "mp_cash_waittime": 48,
        
        // Optional, allow bypass of 3DS on some credit card channels.
        "mp_non_3DS": NSNumber.init(booleanLiteral:true),
    
        // Optional, disable card list option.
        "mp_card_list_disabled": NSNumber.init(booleanLiteral:true),
    
        // Optional for channels restriction, this option has less priority than mp_allowed_channels.
        "mp_disabled_channels": ["credit"]        
    ]

## Start the payment module

### For Objective-C
    MOLPayLib mp = [[MOLPayLib alloc] initWithDelegate:self andPaymentDetails:paymentRequestDict];

### For Swift
    let mp = MOLPayLib(delegate:self, andPaymentDetails: paymentRequestDict)

## Show the payment UI

### For Objective-C
    [self presentViewController:mp animated:NO completion:nil];

### For Swift
    self.present(nc, animated: false) {}

## Close the payment module

### For Objective-C
    [mp closemolpay];

### For Swift
    mp.closemolpay()
    
    * Note: The host application needs to implement the MOLPay payment module manually upon getting a final callback from the close event.

## Payment module callback

### For Objective-C
    - (void)transactionResult: (NSDictionary *)result

### For Swift
    func transactionResult(_ result: [AnyHashable: Any]!) {}

## Payment results
    
    =========================================
    Sample transaction result in JSON string:
    =========================================
    
    {"status_code":"11","amount":"1.01","chksum":"34a9ec11a5b79f31a15176ffbcac76cd","pInstruction":0,"msgType":"C6","paydate":1459240430,"order_id":"3q3rux7dj","err_desc":"","channel":"Credit","app_code":"439187","txn_ID":"6936766"}
    
    Parameter and meaning:
    
    "status_code" - "00" for Success, "11" for Failed, "22" for *Pending. 
    (*Pending status only applicable to cash channels only)
    "amount" - The transaction amount
    "paydate" - The transaction date
    "order_id" - The transaction order id
    "channel" - The transaction channel description
    "txn_ID" - The transaction id generated by MOLPay
    
    * Notes: You may ignore other parameters and values not stated above
    
    =====================================
    * Sample error result in JSON string:
    =====================================
    
    {"Error":"Communication Error"}
    
    Parameter and meaning:
    
    "Communication Error" - Error starting a payment process due to several possible reasons, please contact MOLPay support should the error persists.
    1) Internet not available
    2) API credentials (username, password, merchant id, verify key)
    3) MOLPay server offline.

## Cash channel payment process (How does it work?)

    This is how the cash channels work on XDK:
    
    1) The user initiate a cash payment, upon completed, the XDK will pause at the “Payment instruction” screen, the results would return a pending status.
    
    2) The user can then click on “Close” to exit the MOLPay XDK aka the payment screen.
    
    3) When later in time, the user would arrive at say 7-Eleven to make the payment, the host app then can call the XDK again to display the “Payment Instruction” again, then it has to pass in all the payment details like it will for the standard payment process, only this time, the host app will have to also pass in an extra value in the payment details, it’s the “mp_transaction_id”, the value has to be the same transaction returned in the results from the XDK earlier during the completion of the transaction. If the transaction id provided is accurate, the XDK will instead show the “Payment Instruction" in place of the standard payment screen.
    
    4) After the user done the paying at the 7-Eleven counter, they can close and exit MOLPay XDK by clicking the “Close” button again.

## XDK built-in checksum validator caveats 

    All XDK come with a built-in checksum validator to validate all incoming checksums and return the validation result through the "mp_secured_verified" parameter. However, this mechanism will fail and always return false if merchants are implementing the private secret key (which the latter is highly recommended and prefereable.) If you would choose to implement the private secret key, you may ignore the "mp_secured_verified" and send the checksum back to your server for validation. 

## Private Secret Key checksum validation formula

    chksum = MD5(mp_merchant_ID + results.msgType + results.txn_ID + results.amount + results.status_code + merchant_private_secret_key)

## Support

Submit issue to this repository or email to our support-sa@razer.com

Merchant Technical Support / Customer Care : support-sa@razer.com<br>
Sales/Reseller Enquiry : sales-sa@razer.com<br>
Marketing Campaign : marketin-sa@razer.com<br>
Channel/Partner Enquiry : channel-sa@razer.com<br>
Media Contact : media-sa@razer.com<br>
R&D and Tech-related Suggestion : technical-sa@razer.com<br>
Abuse Reporting : abuse-sa@razer.com
