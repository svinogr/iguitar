//
//  PurchaseManager.swift
//  iguitar
//
//  Created by Up Devel on 26/09/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import SwiftyStoreKit

let userDef = UserDefaults.standard

func checkUserDef()-> Bool {
    let purchased = userDef.bool(forKey: "purchased")
    
    return purchased
}

class PurchaseManager {
    
    let identifier = "com.updevel.iguitar.nonCons"
    static let shared = PurchaseManager()
    
    func getProductWitInfo() -> RetrieveResults? {
        NetworkActivityIndicator.networkOperationStarted()
        var product: RetrieveResults?
        
        SwiftyStoreKit.retrieveProductsInfo([identifier], completion:{
            result in
            // моя ахине странно но работает
            NetworkActivityIndicator.networkOperationFinished()
            
            
            
            product =  result
            
            
        }
        )
        return product
    }
    
    @objc func purchase()  {
        NetworkActivityIndicator.networkOperationStarted()
        let idString = identifier
        SwiftyStoreKit.retrieveProductsInfo([idString]) { result in
            NetworkActivityIndicator.networkOperationFinished()
            if let productRetriv = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(productRetriv, quantity: 1, atomically: true) { result in
                    // handle result (same as above)
                    print(productRetriv.localizedTitle)
                    print(result)
                    switch result {
                    case .success(let productRetriv):
                        // fetch content from your server, then:
                        if productRetriv.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(productRetriv.transaction)
                        }
                        userDef.set(true, forKey: "purchased")
                        // product.isPurchased = true // поставить юзер дефолт тру
                        // self.tableView.reloadData()
                        
                    // print("Purchase Success: \(productRetriv.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        case .privacyAcknowledgementRequired:
                            print("case pokupri")
                        case .unauthorizedRequestData:
                            print("case pokupri")
                        case .invalidOfferIdentifier:
                            print("case pokupri")
                        case .invalidSignature:
                            print("case pokupri")
                        case .missingOfferParams:
                            print("case pokupri")
                        case .invalidOfferPrice:
                            print("case pokupri")
                        @unknown default:
                            print("case pokupri")
                        }
                    }
                }
            }
        }
    }
    
     func restore() {
        NetworkActivityIndicator.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            NetworkActivityIndicator.networkOperationFinished()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                userDef.set(true, forKey: "purchased")
                //   self.setupProducts()
                //  self.tableView.reloadData()  здесть рсторе или юзер дефолтс
                
                print("Restore Success: \(results.restoredPurchases)")
                
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
}
