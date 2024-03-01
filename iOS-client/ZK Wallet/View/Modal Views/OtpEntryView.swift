//
//  OtpEntryView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/6/23.
//

import SwiftUI

import SwiftUI

struct OtpEntryView: View {
    @Binding var otpCode: String
    @Binding var isRequestInProgress: Bool
    var verifyOTP: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter OTP", text: $otpCode)
                .frame(width: 200, height: 45)
                .textFieldStyle(PlainTextFieldStyle())
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.blue, lineWidth: 1))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)

            Button("Verify OTP", action: verifyOTP)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isRequestInProgress)
        }
    }
}

#Preview {
    OtpEntryView(
        otpCode: .constant("1234"),
        isRequestInProgress: .constant(false),
        verifyOTP: {}
    )
}
