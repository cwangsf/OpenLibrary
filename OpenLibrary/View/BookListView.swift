//
//  BookListView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/26/25.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var viewModel: SearchSubjectViewModel
    @Environment(\.isNetworkConnected) var isConnected
    var body: some View {
        if let isConnected = isConnected {
            if isConnected {
                HStack() {
                    Spacer()
                    Text("Show \(Text(String(viewModel.bookItems.count)).foregroundColor(.teal)) of \(viewModel.resultCount) results")
                }
                .padding()
                Divider()
            } else {
                Text("No network, show the local saved books")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .padding()
            }
        }
        List {
            ForEach(viewModel.bookItems, id: \.key) { bookItem in
                NavigationLink(value: bookItem) {
                    BookItemView(bookItem: bookItem)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }
                .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 16))
            }
            
            if let isConnected = isConnected, isConnected {
                if !viewModel.bookItems.isEmpty && viewModel.canLoadMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .task {
                            Task {
                                do {
                                    try await viewModel.loadMore()
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: BookItem.self) { bookItem in
            BookDetailView(bookItem: bookItem)
        }
    }
}
