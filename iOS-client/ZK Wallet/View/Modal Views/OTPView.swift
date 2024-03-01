//
//  OTPView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct OTPView: View {
    var phoneNumber: String
    var organization: OrganizationModel
    @State private var otpCode = ""
    @State private var timeRemaining = 30
    @State private var isOTPVerified = false
    @State private var isRequestInProgress = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            if isOTPVerified {
                OtpSuccessView()
            } else {
                OtpEntryView(otpCode: $otpCode, isRequestInProgress: $isRequestInProgress, verifyOTP: verifyOTP)
            }

            if isRequestInProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .padding()
        .navigationTitle("Verify OTP")
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }

    func verifyOTP() {
        isRequestInProgress = true

        APIManager.shared.verifyOTP(phoneNumber: phoneNumber, otpCode: otpCode, id_type: organization.code) { idModel, error in

            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let idModel = idModel {
                let dbManager = DatabaseManager()
                dbManager.insertIdModel(idModel: idModel)
                self.isOTPVerified = true

                let ageThreshold = 18


                APIManager.shared.executeProofs(UID: idModel.UID, address: idModel.address, dob: idModel.dateOfBirth, ageThreshold: ageThreshold, id_type: organization.code) { proof, error in
                     self.isRequestInProgress = false

                    if let error = error {
                        print("Error in executeProofs: \(error.localizedDescription)")
                    } else if let proof = proof {
                        print(proof)
                        dbManager.insertProof(proof: proof)
                    }
                }
            }
        }
    }
}

#Preview {
    OTPView(phoneNumber: "1234567890", organization: OrganizationModel(id: 1, name: "", code: "", stateId: 1))
}
