//
//  CardStackView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import SwiftUI

struct CardStackView: View {
    @Binding var cards: [CardModel]
    @Binding var selectedCardIndex: Int?
    @Binding var isCardExpanded: Bool

    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                CardView(
                    cardType: card.cardType,
                    cardNumber: card.cardNumber,
                    companySymbol: Image(systemName: card.symbolName),
                    gradientColors: card.gradientColors
                )
                .offset(x: 0, y: CGFloat(index * 30))
                .onTapGesture {
                    withAnimation {
                        selectedCardIndex = index
                        isCardExpanded = true
                    }
                }
            }
        }
    }
}

#Preview {
    CardStackView(
        cards: .constant([
            CardModel(from: IdModel(address: "123 Main St", idType: "UID", firstName: "John", lastName: "Doe", dateOfBirth: 1, phone: "123-456-7890", UID: "1234567890")),
            CardModel(from: IdModel(address: "456 Elm St", idType: "Passport", firstName: "Jane", lastName: "Smith", dateOfBirth: 1, phone: "098-765-4321", UID: "0987654321")),
            CardModel(from: IdModel(address: "456 Elm St", idType: "SSA", firstName: "Jane", lastName: "Smith", dateOfBirth: 1, phone: "098-765-4321", UID: "0987654321"))
        ]),
        selectedCardIndex: .constant(nil),
        isCardExpanded: .constant(false)
    )

}

