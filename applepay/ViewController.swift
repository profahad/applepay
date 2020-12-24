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
    
    private var localPayment: PKPayment?
    
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
        self.localPayment = nil
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
        controller.dismiss(animated: true) {
            if let payment = self.localPayment  {
                self.alert(title: "Transaction", message: "Transaction made successfully.\nHere is transaction Ref # \(payment.token.transactionIdentifier ?? "")")
            }
        }

    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if payment.token.paymentData.base64EncodedString() != nil {
            self.localPayment =  payment;
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        } else {
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.failure, errors: []))
        }
    }
}


extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
}
