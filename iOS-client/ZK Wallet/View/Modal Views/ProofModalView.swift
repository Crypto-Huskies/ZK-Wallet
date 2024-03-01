//
//  ProofModalView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/13/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ProofModalView: View {
    let proof: Proof

    var body: some View {
        VStack {
            Image(systemName: "wifi")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            if let qrImage = generateQRCode(from: createQRData()) {
                Image(uiImage: qrImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .padding()
    }

    private func createQRData() -> String {
        // Convert your Proof object to a JSON string
        if let jsonData = try? JSONEncoder().encode(proof),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            // Encode JSON string in the QR code
            return jsonString
        }
        return "Error"
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        // Convert string to data
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        // Generate QR code
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }

        // Return nil in case of failure
        return nil
    }
}

// Example Preview
struct ProofModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProofModalView(proof: Proof(UID: "1", pi_a: ["a"], pi_b: [["b"]], pi_c: ["c"], protocolType: "Type1", curve: "Curve1", publicSignals: ["public1"], txType: "Transaction1"))
    }
}




#Preview {
    ProofModalView(proof: Proof(UID: "1", pi_a: ["a"], pi_b: [["b"]], pi_c: ["c"], protocolType: "Type1", curve: "Curve1", publicSignals: ["public1"], txType: "Transaction1"))
}


//if let jsonData = try? JSONEncoder().encode(proof) {
//    if let jsonString = String(data: jsonData, encoding: .utf8) {
//         writer.scan(theactualdata: jsonString)
//        
//    }
//}
