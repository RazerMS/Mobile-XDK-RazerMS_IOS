//
//  ViewController.swift
//  MOLPayExampleSwift
//
//  Created by Clement on 04/12/2017.
//  Copyright © 2017 MOLPay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MOLPayLibDelegate {
    var isPaymentInstructionPresent: Bool = false
    var isCloseButtonClick: Bool = false
    var mp = MOLPayLib()
    
    @IBAction func closemolpay(sender: UIBarButtonItem) {
        // Closes MOLPay
        self.mp.closemolpay()
        isCloseButtonClick = true
        print("---Close: \(NSNumber.init(booleanLiteral: true))")
    }
    
    @IBAction func deeplinkToVTApp(sender: UIBarButtonItem) {
        
        let application = UIApplication.shared
        
        let razerVTApp = "molpayvt://mp_url_scheme=molpayvt&mp_amount=1.10&mp_merchant_ID=SB_molpayxdk&mp_verification_key=&mp_order_ID=swift-ios&mp_channel=paynow&mp_bill_description=test payment&mp_bill_name=nick&mp_bill_email=nick@email.com&mp_bill_mobile=0111111111"
        guard let razerVTURL = razerVTApp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        guard let appUrl = URL(string: razerVTURL) else {return }
        
        let websiteUrl = URL(string: "https://razer.com")!
        
        if application.canOpenURL(appUrl) {
            application.open(appUrl, options: [:], completionHandler: nil)
        } else {
            print("cannot open molpayvt")
            application.open(websiteUrl, options: [:], completionHandler: nil)
        }
        
        
    }
    
    @IBAction func startmolpay(sender: UIBarButtonItem) {
        
        // Default setting for Cash channel payment result conditions
        self.isPaymentInstructionPresent = false
        self.isCloseButtonClick = false
        
        // Setup payment details
        let paymentRequestDict: [String:Any] = [
            // Mandatory String. A value more than '1.00'
            "mp_amount": "1.10",
            
            // Mandatory String. Values obtained from MOLPay
            
            //Sandbox account
            "mp_username": "xxxxxx",
            "mp_password": "xxxxxx",
            "mp_merchant_ID": "xxxxxx",
            "mp_app_name": "xxxxxx",
            "mp_verification_key": "xxxxxx",
            
            // Mandatory String. Payment values
            "mp_order_ID": "swift-ios",
            "mp_currency": "MYR",
            "mp_country": "MY",
            
            // Optional String.
            "mp_channel": "multi", // Use 'multi' for all available channels option. For individual channel seletion, please refer to "Channel Parameter" in "Channel Lists" in the MOLPay API Spec for Merchant pdf.
            "mp_bill_description": "billdesc",
            "mp_bill_name": "billname",
            "mp_bill_email": "email@domain.com",
            "mp_bill_mobile": "+1234567",
            //"mp_channel_editing": NSNumber.init(booleanLiteral:false), // Option to allow channel selection.
            //"mp_editing_enabled": NSNumber.init(booleanLiteral:false), // Option to allow billing information editing.
            
            // Optional, enable for online sandbox testing.
            //"mp_dev_mode": NSNumber.init(booleanLiteral:true),
            
            // Optional for Escrow
            //"mp_is_escrow": "0", // Put "1" to enable escrow
            
            // Optional for credit card BIN restrictions
            //"mp_bin_lock": ["414170", "414171"],
            //"mp_bin_lock_err_msg": "Only UOB allowed",
            
            // For transaction request use only, do not use this on payment process
            //"mp_transaction_id": "", // Optional, provide a valid cash channel transaction id here will display a payment instruction screen.
            //"mp_request_type": "",
            
            // Optional, use this to customize the UI theme for the payment info screen, the original XDK custom.css file is provided at Example project source for reference and implementation.
            //"mp_custom_css_url": Bundle.main.path(forResource: "custom.css", ofType: nil)!,
            
            // Optional, set the token id to nominate a preferred token as the default selection, set "new" to allow new card only
            //"mp_preferred_token": "",
            
            // Optional, credit card transaction type, set "AUTH" to authorize the transaction
            //"mp_tcctype": "",
            
            // Optional, set true to process this transaction through the recurring api, please refer the MOLPay Recurring API pdf
            //"mp_is_recurring": NSNumber.init(booleanLiteral:false),
            
            // Optional for channels restriction
            //"mp_allowed_channels": ["credit", "credit3"],
            
            // Optional for sandboxed development environment, set boolean value to enable.
            //"mp_sandbox_mode": NSNumber.init(booleanLiteral:true),
            
            // Optional, required a valid mp_channel value, this will skip the payment info page and go direct to the payment screen.
            //"mp_express_mode": NSNumber.init(booleanLiteral:true),
            
            // Optional, enable this for extended email format validation based on W3C standards.
            //"mp_advanced_email_validation_enabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, enable this for extended phone format validation based on Google i18n standards.
            //"mp_advanced_phone_validation_enabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, explicitly force disable billing name edit.
            //"mp_bill_name_edit_disabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, explicitly force disable billing email edit.
            //"mp_bill_email_edit_disabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, explicitly force disable billing mobile edit.
            //"mp_bill_mobile_edit_disabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, explicitly force disable billing description edit.
            //"mp_bill_description_edit_disabled": NSNumber.init(booleanLiteral:true),
            
            // Optional, EN, MS, VI, TH, FIL, MY, KM, ID, ZH.
            //"mp_language": "EN",
            
            // Optional, Cash channel payment request expiration duration in hour.
            //@"mp_cash_waittime": @"48",
            
            // Optional, allow bypass of 3DS on some credit card channels.
            //"mp_non_3DS": NSNumber.init(booleanLiteral:true),
            
            // Optional, disable card list option.
            //"mp_card_list_disabled": NSNumber.init(booleanLiteral:true),
            
            // Optional for channels restriction, this option has less priority than mp_allowed_channels.
            //"mp_disabled_channels": ["credit"]
        ]
        
        self.mp = MOLPayLib(delegate:self, andPaymentDetails: paymentRequestDict)
        self.mp.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(self.closemolpay)
        )
        self.mp.navigationItem.hidesBackButton = true
        
        // Push method (This requires host navigation controller to be available at this point of runtime process,
        // refer AppDelegate.m for sample Navigation Controller implementations)
        //        self.navigationController?.pushViewController(mp, animated: true)
        
        // Present method (Simple mode)
        let nc = UINavigationController()
        nc.viewControllers = [mp]
        
        self.present(nc, animated: false) {
            print("---presented")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Pay now",
            style: .plain,
            target: self,
            action: #selector(self.startmolpay(sender:))
            //uncomment this to test deeplink
            //action: #selector(self.deeplinkToVTApp(sender:))
            
        )
        
    }
    
    // @MOLPayLibDelegates
    func transactionResult(_ result: [AnyHashable: Any]!) {
        
        // Payment status results returned here
        print("transactionResult result = \(result)")
        if(result["status_code"] as? String == "11"){
            self.dismiss(animated: true); // to your failed page
        }else if(result["status_code"] as? String == "00"){
            self.dismiss(animated: true); // to your success page
        }else{
            if(result["pInstruction"] as? NSNumber == 1){
            }else{
                self.dismiss(animated: true); //others
            }
        }
    }
    
}

