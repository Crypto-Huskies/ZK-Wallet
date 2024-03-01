//
//  CardView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/24/24.
//

import SwiftUI

struct CardView: View {
    var cardType: String
    var cardNumber: String
    var companySymbol: Image
    var gradientColors: [Color]

    var maskedCardNumber: String {
        
        guard cardNumber.count > 4 else {
            return cardNumber 
        }
        return "*** ** " + cardNumber.suffix(4)
    }

    var body: some View {
        ZStack {
            // Customizable Gradient Background
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()

            VStack(alignment: .leading) {
                HStack {
                    // Company Symbol
                    companySymbol
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(40)

                    Spacer()
                    
                    // Card Type Name
                    Text(cardType)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 40)
                        .offset(y: -30) // Offset upwards
                }

                Spacer()

                // Masked Card Number
                Text(maskedCardNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(40)
            }
        }
        .frame(height: 250)
    }
}

#Preview {
    CardView(
        cardType: "Social Security",
        cardNumber: "000 00 9988",
        companySymbol: Image(systemName: "building.columns.fill"),
        gradientColors: [Color.blue, Color.purple]
    )
}
