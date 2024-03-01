//
//  NoCardsView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 02/26/24.
//

import SwiftUI

struct NoCardsView: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Text("No Cards Added")
                .font(.headline)
                .padding(.bottom, 20)
            
            Button(action: {
                self.selectedTab = 1 
            }) {
                HStack {
                    Image(systemName: "plus.app")
                        .imageScale(.large)
                    Text("Add Cards")
                        .fontWeight(.medium)
                }
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    NoCardsView(selectedTab: .constant(1))
}




