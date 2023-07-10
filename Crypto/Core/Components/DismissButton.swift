//
//  DismissButton.swift
//  Crypto
//
//  Created by Feni Brian on 20/06/2022.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "xmark")
                Text("Close")
            }
            .foregroundColor(Color.theme.red)
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
            .previewLayout(.sizeThatFits)
    }
}
