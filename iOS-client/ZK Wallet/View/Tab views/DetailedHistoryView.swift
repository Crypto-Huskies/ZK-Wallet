//
//  DetailedHistoryView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct DetailedHistoryView: View {
    @State private var isProofVerified: Bool? = nil
    @State private var isLoading: Bool = false

    var transaction: Transaction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Transaction ID: \(transaction.txId)")
            Text("From: \(transaction.from)")
            Text("Message: \(transaction.message)")
            if let timestamp = transaction.timestamp {
                Text("Timestamp: \(formatDate(timestamp))")
            }

            HStack {
                Button(action: {
                    sendProof()
                }) {
                    Text("Send Proof")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            if isLoading {
                ProgressView()
            } else if isProofVerified == true {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Proof Accepted")
                        .foregroundColor(.green)
                }
            } else if isProofVerified == false {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("Proof Rejected")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .navigationTitle("History Details")
    }

    private func sendProof() {
        isLoading = true
        let dbManager = DatabaseManager()
        print("send")
        guard let proof = dbManager.getProofForTxType(txTypeValue: transaction.txType ?? "") else {
            print("Proof not found for txType: \(String(describing: transaction.txType))")
            isLoading = false
            return
        }

        APIManager().sendProof(proof: proof) { result in
            isLoading = false
            switch result {
            case let .success(proofResult):
                print("Proof sent successfully")
                self.isProofVerified = proofResult
            case let .failure(error):
                print("Error sending proof: \(error)")
                self.isProofVerified = false
            }
        }
    }
}

#Preview {
    DetailedHistoryView(
        transaction: Transaction(txId: "1", from: "J Vue", message: "Are you above 18?", timestamp: "2023-12-10T11:46:21-05:00", txType: "18")
    )
}
