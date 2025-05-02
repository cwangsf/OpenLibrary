//
//  BookItemView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/23/25.
//

import SwiftUI

struct BookItemView: View {
    @Environment(\.isNetworkConnected) var isConnected
    @Environment(\.modelContext) var modelContext
    @State private var loadedImage: Image?
    let bookItem: BookItem
    let defaultImage = Image(systemName: "book.fill")
    let imageCornerRadius: CGFloat = 5
    let imageWidth: CGFloat = 50
    
    var body: some View {
        HStack {
            if let isConnected = isConnected , !isConnected {
                if let imageData = bookItem.coverImageData,
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
                AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(String(coverid))-S.jpg")) { image in
                    image.resizable()
                        .cornerRadius(imageCornerRadius)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageWidth * 1.2)
                        .onAppear {
                            if bookItem.coverImageData == nil,
                                let url = URL(string: "https://covers.openlibrary.org/b/id/\(String(coverid))-S.jpg") {
                                Task {
                                    do {
                                        let (data, _) = try await URLSession.shared.data(from: url)
                                        await MainActor.run {
                                            bookItem.coverImageData = data
                                            try? modelContext.save()
                                        }
                                    } catch {
                                        // Optionally handle error (e.g., print or ignore)
                                    }
                                }
                            }
                        }
                } placeholder: {
                    defaultImage
                }
            } else {
                defaultImage
            }
            
            VStack(alignment: .leading) {
                Text(bookItem.title)
                    .font(.headline)
                Spacer()
                Text("by \(Text(bookItem.authorNames).foregroundColor(.teal).bold())")
                    .font(.caption)
            }
            .padding()
        }
        .padding()
    }
}
