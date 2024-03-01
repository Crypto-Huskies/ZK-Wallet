//
//  ProofModel.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/25/24.
//

import Foundation

struct Proof: Encodable {
    let UID: String
    let pi_a: [String]
    let pi_b: [[String]]
    let pi_c: [String]
    let protocolType: String
    let curve: String
    let publicSignals: [String]
    let txType: String?

    static func from(dictionary: [String: Any]) -> Proof? {
        guard let UID = dictionary["UID"] as? String,
              let proofDict = dictionary["proof"] as? [String: Any],
              let pi_a = proofDict["pi_a"] as? [String],
              let pi_b_Array = proofDict["pi_b"] as? [[Any]],
              let pi_c = proofDict["pi_c"] as? [String],
              let protocolType = proofDict["protocol"] as? String,
              let curve = proofDict["curve"] as? String,
              let publicSignals = dictionary["publicSignals"] as? [String],
              let txType = dictionary["txType"] as? String else { 
            return nil
        }

        let pi_b = pi_b_Array.map { $0.compactMap { "\($0)" } }

        return Proof(UID: UID, pi_a: pi_a, pi_b: pi_b, pi_c: pi_c, protocolType: protocolType, curve: curve, publicSignals: publicSignals, txType: txType)
    }
}



