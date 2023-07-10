//
//  LaunchView.swift
//  Crypto
//
//  Created by Feni Brian on 02/07/2022.
//

import SwiftUI

// This is the view you see once the app launches on th phone.
struct LaunchView: View {
    @Binding var isLoading: Bool
    @State private var showLoadingAnimation: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    private let ellipsisSize: CGFloat = 7
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea(.all)
            Image("logo-transparent")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 112, height: 112)
            ZStack(alignment: .bottom) {
                if showLoadingAnimation {
                    HStack(spacing: 5) {
                        Text("Loading")
                            .bold()
//                        ProgressView()
                        ellipses
                    }
                    .foregroundColor(Color.launch.accent)
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(x: 0, y: 300)
        }
        .onAppear(perform: { showLoadingAnimation.toggle() })
        .onReceive(timer, perform: {_ in
            withAnimation(Animation.easeInOut(duration: 0.25).delay(0.2).repeatForever(autoreverses: true)) {
                counter += 1
                loops += 1
            }
            if loops > 5 {
                isLoading = false
            }
        })
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(isLoading: .constant(true))
    }
}

extension LaunchView {
    private var ellipses: some View {
        HStack {
            ForEach(0..<3, id: \.self) {index in
                Circle()
                    .foregroundColor(Color.launch.accent.opacity(counter == index ? 0.3 : 1.0))
                    .frame(width: ellipsisSize, height: ellipsisSize, alignment: .bottom)
            }
        }
    }
}
