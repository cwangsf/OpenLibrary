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
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            Image("openLib")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 50)
            
            if let isConnected = isConnected, !isConnected {
                Text("There is no internet connection, but you can still see some previous search results.")
                    .font(.caption)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            
            HomeImageView(homeImages: HomeImageViewModel.sampleImages)
        }
    }
}

struct HomeImageView: View {
    let homeImages: [HomeImageModel]
    
    var body: some View {
        
        List {
            ForEach(homeImages) { homeImage in
                ZStack {
                    Image(homeImage.image)
                        .resizable()
                        .scaledToFill()
                    VStack {
                        Spacer()
                        Text(homeImage.quote.quoteText)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical)
                        HStack {
                            Spacer()
                            Text("- " + homeImage.quote.author)
                        }
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(\.isNetworkConnected, false)
}
