//
//  BookDetailView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/23/25.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    let bookItem: BookItem
    @Environment(\.modelContext) var modelContext
    @Environment(\.isNetworkConnected) private var isConnected
    @StateObject var viewModel: BookDetailViewModel
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @Query private var savedBookInfos: [BookInfo]
    
    init(bookItem: BookItem) {
        self.bookItem = bookItem
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(bookItem: bookItem))
    }
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading Book Info...")
            } else {
                if let bookInfo = viewModel.bookInfo {
                    BookDetailContentView(
                        bookItem: bookItem,
                        bookInfo: bookInfo)
                }
            }
        }
        .alert(item: $viewModel.error) { identifiableError in
            Alert(
                title: Text("Error"),
                message: Text(identifiableError.error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    viewModel.error = nil
                    dismiss()
                }
            )
        }
        .task {
            viewModel.modelContext = modelContext
            await loadBookInfo()
        }
    }
    
    private func loadBookInfo() async {
        if let isConnected = isConnected, isConnected {
            isLoading = true
            await viewModel.fetchBookInfo()
        } else if let savedBook = savedBookInfos.first(where: { $0.key == bookItem.key }) {
                viewModel.bookInfo = savedBook
        } else {
            viewModel.error = IdentifiableError(error: DataError.unknown)
        }
        isLoading = false
    }
}

struct BookDetailContentView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.isNetworkConnected) var isConnected
    let bookItem: BookItem
    let defaultImage: Image = Image(systemName: "book.fill")
    let imageCornerRadius: CGFloat = 10
    let imageWidth: CGFloat = 120
    let bookInfo: BookInfo
    
    var body: some View {
        VStack {
            if let isConnected = isConnected , !isConnected {
                if let imageData = bookInfo.coverImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(imageCornerRadius)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageWidth * 1.2)
                } else {
                    defaultImage
                }
            } else if let coverid = bookItem.coverid {
                AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(String(coverid))-M.jpg")) { image in
                    image.resizable()
                        .cornerRadius(imageCornerRadius)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageWidth * 1.2)
                        .onAppear {
                            if bookInfo.coverImageData == nil,
                                let url = URL(string: "https://covers.openlibrary.org/b/id/\(String(coverid))-M.jpg") {
                                Task {
                                    do {
                                        let (data, _) = try await URLSession.shared.data(from: url)
                                        await MainActor.run {
                                            bookInfo.coverImageData = data
                                            try? modelContext.save()
                                        }
                                    } catch {
                                        // Optionally handle error (e.g., print or ignore)
                                    }
                                }
                            }
                        }
                        
                } placeholder: {
                    ProgressView()
                        .font(.system(size: 50))
                }
            } else {
                defaultImage
                    .font(.system(size: 150))
            }
            VStack {
                Text(bookInfo.title)
                    .font(.largeTitle)
                    .padding(.vertical)
                if let publishDate = bookInfo.publishDate {
                    Text("Publish Date: \(publishDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("by \(Text(bookItem.authorNames).foregroundColor(.teal).bold())")
                   
                Text(bookInfo.bookDescription)
                    .padding()
            }
            Spacer()
        }
        .padding()
    }
}
