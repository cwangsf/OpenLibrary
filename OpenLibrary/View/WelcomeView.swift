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
    @State private var currentPage = 0
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(homeImages.enumerated()), id: \.element.id) { index, homeImage in
                ZStack {
                    Image(homeImage.image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    VStack {
                        Spacer()
                        Text(homeImage.quote.quoteText)
                            .italic()
                            .multilineTextAlignment(.leading)
                            .font(.largeTitle)
                            .padding()
                        HStack {
                            Spacer()
                            Text("- " + homeImage.quote.author)
                        }
                        .padding()
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation {
                currentPage = (currentPage + 1) % homeImages.count
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(\.isNetworkConnected, false)
}
