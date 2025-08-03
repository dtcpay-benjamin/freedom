//
//  SHTSubscriptionHelper.swift
//  seaHorseTheater
//
//  Created by 褚红彪 on 8/2/25.
//

import Foundation
import StoreKit

@objc class SHTSubscriptionHelper: NSObject {
    @MainActor @objc static let shared = SHTSubscriptionHelper()

    /// 查询当前订阅状态
//    @objc func fetchSubscriptionStatus(completion: @escaping (String) -> Void) {
//        Task {
//            do {
//                let entitlements = try await Transaction.currentEntitlements
//                var activeSubs: [String] = []
//
//                for try await transaction in entitlements {
//                    if case .verified(let verified) = transaction {
//                        activeSubs.append(verified.productID)
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    if activeSubs.isEmpty {
//                        completion("无订阅")
//                    } else {
//                        completion("已订阅：\(activeSubs.joined(separator: ","))")
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion("查询失败：\(error.localizedDescription)")
//                }
//            }
//        }
//    }
}
