//
//  Transaction.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import Foundation

struct Transaction: Hashable {
    let txId: String
    let from: String
    let message: String
    let timestamp: String?
    let txType: String?
}


