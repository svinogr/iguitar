//
//  IAPManager.swift
//  iguitar
//
//  Created by Up Devel on 02/09/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    static let  shared = IAPManager()
    var product: [SKProduct] = []
    
    private override init() {}
    
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callback(true)
             print(true)
            return
        }
        print(false)
        callback(false)
    }
    
    public func getProducts() {
        print("products")
        let productRequest = SKProductsRequest(productIdentifiers: ["com.updevel.iguitar.nonCons"])
        productRequest.delegate = self
        productRequest.start()
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.product = response.products
        
        //.product.forEach{print($0.isP)}

    }
    

}
