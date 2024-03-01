//
//  AppTabView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct AppTabView: View {
    @State var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            WalletView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Wallet", systemImage: "creditcard.fill")
                }
                .tag(0)
            
            StateListView()
                .tabItem {
                    Label("Import ID", systemImage: "note.text.badge.plus")
                }
                .tag(1)
            
            HistoryListView()
                .tabItem {
                    Label("History", systemImage: "note.text")
                }
                .tag(2)
        }
        .accentColor(.primary)
    }
}

#Preview {
    AppTabView()
}
