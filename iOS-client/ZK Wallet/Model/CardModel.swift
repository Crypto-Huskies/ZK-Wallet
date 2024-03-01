//
//  CardModel.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/25/24.
//

import SwiftUI

struct CardModel {
    var cardType: String
    var cardNumber: String
    var symbolName: String
    var gradientColors: [Color]

    init(from idModel: IdModel) {
        self.cardType = idModel.idType
        self.cardNumber = idModel.UID
        self.symbolName = "building.columns.fill" 
        self.gradientColors = CardModel.gradientColors(for: idModel.idType)
    }

    static func gradientColors(for idType: String) -> [Color] {
        switch idType {
        case "RMV":
            return [Color.red, Color.orange]
        case "SSA":
            return [Color.green, Color.blue]
        case "DHS":
            return [Color.purple, Color.red]
        case "UID":
            return [Color.orange, Color.green]
        default:
            return [Color.gray]
        }
    }
}
