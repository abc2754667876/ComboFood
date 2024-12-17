//
//  Purchase.swift
//  ComboFood
//
//  Created by Chengzhi 张 on 2024/12/16.
//

import Foundation
import StoreKit

class IAPManager: NSObject, ObservableObject {
    static let shared = IAPManager() // 单例

    @Published var products: [SKProduct] = [] // 可供购买的产品
    @Published var purchaseStatus: String? // 购买状态（UI中展示用）

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self) // 注册观察者
    }

    private let productIdentifiers: Set<String> = [
        "ComboFood.give.cola",  // 替换为你的产品ID
        "ComboFood.give.coffee",
        "ComboFood.give.milktea"
    ]

    /// 请求产品信息
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    /// 开始购买
    func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            purchaseStatus = "用户无法购买商品"
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func product(for identifier: String) -> SKProduct? {
        return products.first(where: { $0.productIdentifier == identifier })
    }

    /// 恢复购买
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
        if response.invalidProductIdentifiers.count > 0 {
            print("无效的产品ID: \(response.invalidProductIdentifiers)")
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            DispatchQueue.main.async {
                switch transaction.transactionState {
                case .purchased:
                    self.purchaseStatus = "购买成功: \(transaction.payment.productIdentifier)"
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .failed:
                    if let error = transaction.error {
                        self.purchaseStatus = "购买失败: \(error.localizedDescription)"
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .restored:
                    self.purchaseStatus = "恢复成功: \(transaction.payment.productIdentifier)"
                    SKPaymentQueue.default().finishTransaction(transaction)
                default:
                    break
                }
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async {
            self.purchaseStatus = "恢复购买完成"
        }
    }
}
