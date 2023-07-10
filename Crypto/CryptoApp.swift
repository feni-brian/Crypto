//
//  CryptoApp.swift
//  Crypto
//
//  Created by Feni Brian on 06/06/2022.
//

import SwiftUI

@main
struct CryptoApp: App {
//    let persistenceController = PersistenceController.shared
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
//                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                ZStack {
                    if showLaunchView {
                        LaunchView(isLoading: $showLaunchView)
                            .transition(.move(edge: .trailing))
                    }
                }
                .zIndex(2.0)
            }
            .onAppear(perform: { showLaunchView.toggle() })
        }
    }
}
