//
//  WalletView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import LocalAuthentication
import SwiftUI

struct WalletView: View {
    @Binding var selectedTab: Int
    @State private var cards: [CardModel] = []
    @State private var proofs: [Proof] = []
    @State private var selectedProof: Proof?
    @State private var isModalPresented = false
    @State private var selectedCardIndex: Int? = nil
    @State private var isCardExpanded: Bool = false
    @State var writer = NFCReader()

    var body: some View {
        ScrollView {
            VStack {
                if cards.isEmpty {
                    NoCardsView(selectedTab: $selectedTab)
                } else if let selectedIndex = selectedCardIndex, isCardExpanded {
                    ExpandedCardView(card: cards[selectedIndex], isCardExpanded: $isCardExpanded)
                } else {
                    CardStackView(cards: $cards, selectedCardIndex: $selectedCardIndex, isCardExpanded: $isCardExpanded)
                }

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(proofs, id: \.UID) { proof in
                        Button(action: {
                            self.selectedProof = proof
                            self.authenticateUser(proof: proof)
                        }) {
                            ProofCell(proof: proof)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                fetchCardsFromDatabase()
            }
        }
    }

    private func fetchCardsFromDatabase() {
        let dbManager = DatabaseManager()
        let idModels = dbManager.getIdModels()
        cards = idModels.map { CardModel(from: $0) }
        proofs = dbManager.getProofs()
    }

    private func authenticateUser(proof: Proof) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to view proof"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        if let jsonData = try? JSONEncoder().encode(proof) {
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                writer.scan(theactualdata: jsonString)
                            }
                        }
                    } else {
                        print("failed")
                    }
                }
            }
        } else {
            print("unavailable")
        }
    }
}

#Preview {
    WalletView(selectedTab: .constant(0))
}
