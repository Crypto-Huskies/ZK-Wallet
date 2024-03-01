//
//  ProofsView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/13/23.
//

import SwiftUI

struct ProofCell: View {
    let proof: Proof

    var body: some View {
        HStack {
            Image(systemName: "seal.fill")
            Text("Proof \(proof.txType ?? "")")
            
            Spacer()
        }
        .frame(width: 300, height: 50)
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}


#Preview {
    ProofCell(proof: Proof(UID: "", pi_a: ["String"], pi_b: [["String"]], pi_c: ["String"], protocolType: "String", curve: "String", publicSignals: ["String"], txType: "Are you 18?"))
}




