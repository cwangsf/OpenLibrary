//
//  BookDetailViewModel.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/27/25.
//
import Combine
import SwiftData
import Foundation

class BookDetailViewModel: ObservableObject {
    @Published var bookInfo: BookInfo?
    @Published var error: IdentifiableError?

    let bookItem: BookItem
    var modelContext: ModelContext?

    init(bookItem: BookItem, modelContext: ModelContext? = nil) {
        self.bookItem = bookItem
        self.modelContext = modelContext
    }

    func fetchBookInfo() async {
        do {
            let info = try await getBookInfo()
            await MainActor.run {
                self.bookInfo = info
            }
        } catch {
            await MainActor.run {
                self.error = IdentifiableError(error: error)
            }
        }
    }
    
    func getBookInfo() async throws -> BookInfo {
        guard let url = URL(string: "https://openlibrary.org/\(bookItem.key).json") else {
            throw DataError.invalidURL
        }
        let request = URLRequest(url: url)
        print("Info: get a book: \(url)")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                let bookInfo = try JSONDecoder().decode(BookInfo.self, from: data)
                if let modelContext = modelContext {
                    modelContext.insert(bookInfo)
                }
                return bookInfo
            } catch let decodingError as DecodingError {
                print("Error: decoding failed: \(decodingError)")
                throw DataError.decodingFailed(decodingError)
            } catch {
                throw error 
            }
        } catch {
            throw DataError.networkError(error)
        }
    }
}
