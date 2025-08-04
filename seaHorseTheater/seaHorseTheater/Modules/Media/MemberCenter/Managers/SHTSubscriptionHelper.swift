//
//  SHTSubscriptionHelper.swift
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/2/25.
//

import Foundation
import StoreKit

@objc class SHTSubscriptionHelper: NSObject {
    
    @objc class func shared() -> SHTSubscriptionHelper {
        return SHTSubscriptionHelper()
    }
    
    // 查询当前订阅状态
    @objc func fetchSubscriptionStatus(completion: @escaping @Sendable (String) -> Void) {
        let safeCompletion = completion

        Task {
            var activeSubs: [String] = []

            for await transaction in Transaction.currentEntitlements {
                if case .verified(let verified) = transaction {
                    activeSubs.append(verified.productID)
                }
            }

            DispatchQueue.main.async {
                if activeSubs.isEmpty {
                    // 无订阅返回空字符串
                    safeCompletion("")
                } else {
                    // 有订阅，返回所有订单id的拼接字符串
                    safeCompletion(activeSubs.joined(separator: ","))
                }
            }
        }
    }
}
