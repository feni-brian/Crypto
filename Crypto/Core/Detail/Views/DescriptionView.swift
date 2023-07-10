//
//  DescriptionView.swift
//  Crypto
//
//  Created by Feni Brian on 30/06/2022.
//

import SwiftUI

struct DescriptionView: View {
    @Binding var showDescriptionSheet: Bool
    var description: String
    
    init(description: String, showDescriptionSheet: Binding<Bool>) {
        self.description = description
        _showDescriptionSheet = .constant(false)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Capsule()
                    .frame(width: 50, height: 5, alignment: .center)
                    .foregroundColor(Color.black.opacity(0.4))
                Spacer()
            }
            .padding(.vertical, 5)
            ScrollView {
                ZStack {
                    Text(description)
                        .foregroundColor(Color.theme.accent)
                }
                .padding()
            }
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(description: "Coin description", showDescriptionSheet: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
