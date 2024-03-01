//
//  StateRowView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/6/23.
//

import SwiftUI

struct StateRowView: View {
    var model: StateModel

    var body: some View {
        HStack {
            Image(systemName: "globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(.trailing, 10)

            Text(model.name)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StateRowView(model: StateModel(id: 1, name: "Massachusettes", code: "RMV"))
}
