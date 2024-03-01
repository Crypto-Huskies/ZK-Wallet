//
//  HistoryListView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct HistoryListView: View {
    @State private var transactionHistory: [Transaction] = []

    var body: some View {
        NavigationView {
            List(transactionHistory, id: \.txId) { transaction in
                NavigationLink(destination: DetailedHistoryView(transaction: transaction)) {
                    HistoryCell(transaction: transaction)
                }
            }
            .navigationTitle("Proof History")
            .onAppear(perform: loadTransactions)
        }
    }

    private func loadTransactions() {
        let dbManager = DatabaseManager()
        transactionHistory = dbManager.getTransactions()
    }
}


#Preview {
    HistoryListView()
}


