//
//  ProductService.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

protocol IProductService {
    func purchasesInit()
    func buyAddsOff(completion: @escaping PurchaseProductCompletion)
    func restorePurchases(completion: @escaping (PurchaseProductResult) -> Void)
}

class ProductService: IProductService {
    
    private let purchases: Purchases
    
    init(purchases: Purchases) {
        self.purchases = purchases
    }
    
    private enum Products {
        case removeAdds
        
        var id: String {
            switch self {
            case .removeAdds:
                return "Remove_adds"
            }
        }
    }
    
    func purchasesInit() {
        purchases.initialize() {_ in }
    }
    
    func buyAddsOff(completion: @escaping PurchaseProductCompletion) {
        purchases.purchaseProduct(productId: Products.removeAdds.id, completion: completion)
    }
    
    func restorePurchases(completion: @escaping (PurchaseProductResult) -> Void) {
        purchases.restorePurchases(completion: completion)
    }
}
