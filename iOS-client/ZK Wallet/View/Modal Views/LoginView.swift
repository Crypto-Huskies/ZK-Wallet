//
//  LoginView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import Combine
import SwiftUI

struct LoginView: View {
    var organization: OrganizationModel
    @State private var phoneNumber: String = ""
    @State private var otpSent = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.red)
                    }
                    .padding([.top, .trailing])
                }

                Image(systemName: "building.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)

                Text(organization.name)
                    .font(.title)
                    .padding(.bottom, 20)

                TextField("Enter phone number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.phonePad)

                Button("Get OTP") {
                    if isValidPhoneNumber(phoneNumber) {
                        APIManager().sendOTPRequest(phoneNumber: phoneNumber, id_type: organization.code) { success in
                            if success {
                                otpSent = true
                            } else {
                                alertMessage = "Failed to send OTP. Please try again."
                                showAlert = true
                            }
                        }
                    } else {
                        alertMessage = "Number invalid"
                        showAlert = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                NavigationLink(destination: OTPView(phoneNumber: phoneNumber, organization: organization), isActive: $otpSent) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LoginView(organization: OrganizationModel(id: 1, name: "Registry Of Motor Vehicles", code: "RMV", stateId: 1))
}
