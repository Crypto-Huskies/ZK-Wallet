//
//  HistoryCell.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct HistoryCell: View {
    var transaction: Transaction

    var body: some View {
        HStack {
            
            Image(systemName: "building.2.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(transaction.from)
                    .font(.headline)
                Text(formatDate(transaction.timestamp!))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(transaction.message)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    HistoryCell(
        transaction: Transaction(txId: "1", from: "JVUE", message: "Are you above 18?", timestamp: "2023-12-10T11:46:21-05:00", txType: "18")
    )
}
