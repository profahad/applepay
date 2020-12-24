//
//  ViewController.swift
//  applepay
//
//  Created by Muhammad Fahad on 21/12/2020.
//

import UIKit
import PassKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonBuy: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        self.setupViews()
    }
    
    private func setupViews() {
        self.buttonBuy.layer.cornerRadius = 22
    }
    
    
    @IBAction func purchaseItem(_ sender: Any) {
        self.requestPayment(product: "Canon EOS 80D DSLR", price: 199.0)
    }
    
}


extension ViewController:PKPaymentAuthorizationViewControllerDelegate{
    
    func requestPayment(product: String, price: Double) {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.stackcru.applepay"
        request.supportedNetworks = [PKPaymentNetwork.visa,
                                     PKPaymentNetwork.masterCard,
                                     PKPaymentNetwork.amex,
                                     PKPaymentNetwork.discover,
                                     PKPaymentNetwork.discover,
                                     PKPaymentNetwork.quicPay]
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: product, amount: NSDecimalNumber(value: price))
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self
        self.present(applePayController!, animated: true, completion: nil)
    }
    
    func alert(title: String? = nil, message: String?) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            //Cancel Action
        }))
        self.present(alertVc, animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.alert(title: "Transaction", message: "Transaction made successfully.\nHere is transaction Ref # \(payment.token.transactionIdentifier ?? "")")
        }
        
    }
}
