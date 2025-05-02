//
//  WelcomeView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/24/25.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.isNetworkConnected) private var isConnected
    
    var body: some View {
        VStack {
            
            Text("Welcome to the")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            Image("openLib")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
            
            if let isConnected = isConnected, !isConnected {
                Text("There is no internet connection, but you can still see some previous search results.")
                    .font(.caption)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(\.isNetworkConnected, false)
}
