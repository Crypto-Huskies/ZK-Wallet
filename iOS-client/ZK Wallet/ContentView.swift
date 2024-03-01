//
//  ContentView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: Double = 0
    @State private var isLoadingComplete = false

    var body: some View {
        if isLoadingComplete {
            AppTabView()
        } else {
            VStack {
                Image("ZKW-Logo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.tint)

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .onAppear {
                // Initial wait with no progress change
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // First phase: Move to 35% in 2 seconds
                    withAnimation(.linear(duration: 1)) {
                        progress = 0.35
                    }

                    // Second phase: Wait for 2 seconds, then move to 80%
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.linear(duration: 1)) {
                            progress = 0.80
                        }

                        // Third phase: Wait for 1 second, then move to 100%
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.linear(duration: 1)) {
                                progress = 1.0
                            }

                            // Finally, after 2 more seconds, change the view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isLoadingComplete = true
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
