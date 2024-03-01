//
//  StateModel.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/24/24.
//

import Foundation

struct StateModel: Decodable, Identifiable {
    var id: Int
    var name: String
    var code: String
}
