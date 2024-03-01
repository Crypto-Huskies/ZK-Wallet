//
//  IdModel.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/25/24.
//

import SwiftUI

struct IdModel {
    var address: String
    var idType: String
    var firstName: String
    var lastName: String
    var dateOfBirth: Int
    var phone: String
    var UID: String
}

extension IdModel {
    static func from(dictionary: [String: Any]) -> IdModel {
        
        return IdModel(
            address: dictionary["address"] as? String ?? "",
            idType: dictionary["idType"] as? String ?? "",
            firstName: dictionary["firstName"] as? String ?? "",
            lastName: dictionary["lastName"] as? String ?? "",
            dateOfBirth: dictionary["dateOfBirth"] as? Int ?? 0,
            phone: dictionary["phone"] as? String ?? "",
            UID: dictionary["UID"] as? String ?? ""
        )
    }
}
