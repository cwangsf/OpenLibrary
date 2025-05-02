//
//  EmptyListView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/26/25.
//

import SwiftUI

struct EmptyListView: View {
    @Environment(\.isNetworkConnected) var isConnected
    let searchText: String
    
    var body: some View {
        Group {
            if let isConnected = isConnected, !isConnected {
                VStack {
                    Text("No network connection.")
                        .font(.title)
                        .padding()
                    Text("No saved books for this subject: \(Text(searchText).foregroundColor(.blue)).")
                        .font(.largeTitle)
                        .padding()
                }
            } else {
                VStack {
                    Text("No book found for subject: \(Text(searchText).foregroundColor(.blue)).")
                        .font(.title)
                }
            }
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    EmptyListView(searchText: "Love")
        .environment(\.isNetworkConnected, true)
}
#Preview {
    EmptyListView(searchText: "Love")
        .environment(\.isNetworkConnected, false)
        
}
