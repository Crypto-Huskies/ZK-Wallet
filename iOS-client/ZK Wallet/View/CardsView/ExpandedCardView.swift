//
//  ExpandedCardView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import SwiftUI

struct ExpandedCardView: View {
    var card: CardModel
    @Binding var isCardExpanded: Bool

    var body: some View {
        VStack {
            CardView(
                cardType: card.cardType,
                cardNumber: card.cardNumber,
                companySymbol: Image(systemName: card.symbolName),
                gradientColors: card.gradientColors
            )
            .onTapGesture {
                withAnimation {
                    isCardExpanded = false
                }
            }

            List {
                Text("Are you above 18?")
                Text("Are you above 21?")
                Text("is your credit score > 750?")
            }
        }
    }
}

#Preview {
    ExpandedCardView(
        card: CardModel(from: IdModel(address: "123 Main St", idType: "SSA", firstName: "John", lastName: "Doe", dateOfBirth: 1, phone: "123-456-7890", UID: "1234567890")), isCardExpanded: .constant(true)
        )
            
}
