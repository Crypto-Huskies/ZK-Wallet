//
//  OtpSuccessView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/6/23.
//

import SwiftUI

struct OtpSuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)

            Text("Card added to wallet")
                .font(.title)
                .foregroundColor(.green)
        }
    }
}

#Preview {
    OtpSuccessView()
}
