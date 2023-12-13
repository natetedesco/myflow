//
//  PurchaseManager.swift
//  MyFlow
//  Created by Nate Tedesco on 5/30/23.
//

import StoreKit
import SwiftUI

@MainActor
class PurchaseManager: ObservableObject {
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    let productIds = ["pro_yearly"]
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    @Published var selectedProduct: Product? = nil
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.selectedProduct = products[0]
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            print("success")
            break
        case .pending:
            print("pending")
            break
        case .userCancelled:
            print("cancled")
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                proAccess = true
                print("success")
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
                proAccess = false
                print("failed")
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
            Task(priority: .background) {
                for await _ in Transaction.updates {
                    await self.updatePurchasedProducts()
                }
            }
        }
}
