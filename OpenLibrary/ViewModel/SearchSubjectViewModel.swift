//
//  SearchSubjectViewModel.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/22/25.
//
import Foundation
import Combine
import Observation
import SwiftData

enum SearchStatus {
    case initial
    case firstLoading
    case loaded
    case empty
}

class SearchSubjectViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var bookItems = [BookItem]()
    @Published var canLoadMore = true
    @Published var searchStatus: SearchStatus = .initial
    @Published var resultCount = 0
    private let limit = 10
    private var offset = 0
    var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func search(subject: String) async throws {
        await MainActor.run {
            bookItems.removeAll()
            canLoadMore = true
            searchStatus = .firstLoading
            resultCount = 0
        }
        offset = 0
        try await loadMore()
    }
    
    func loadMore() async throws {
        guard offset < resultCount || resultCount == 0 else {
            return
        }
        
        let data = try await searchBySubject(searchText, offset: offset)
        let response = try JSONDecoder().decode(SearchSubjectResponse.self, from: data)

        await MainActor.run {
            resultCount = response.numFound
            if resultCount == 0 {
                searchStatus = .empty
            } else {
                self.bookItems.append(contentsOf: response.books)
                
                if let modelContext = modelContext {
                    let currentSearchText = searchText
                    let fetchDescriptor = FetchDescriptor<OfflineSubjectMap>(
                        predicate: #Predicate { $0.subject == currentSearchText }
                    )
                    if let existingMap = try? modelContext.fetch(fetchDescriptor).first {
                        let existingKeys = Set(existingMap.bookItemList.map { $0.key })
                        let newBooks = response.books.filter { !existingKeys.contains($0.key) }
                        for book in newBooks {
                            modelContext.insert(book)
                            try? modelContext.save()
                        }
                        existingMap.bookItemList.append(contentsOf: newBooks)
                        try? modelContext.save()
                    } else {
                        for book in bookItems {
                            modelContext.insert(book)
                        }
                        let newMap = OfflineSubjectMap(subject: searchText, bookItemList: bookItems)
                        modelContext.insert(newMap)
                    }
                }
                
                offset += response.books.count
                canLoadMore = response.books.count == limit
                searchStatus = .loaded
            }
        }
    }
    
    private func searchBySubject(_ subject: String, offset: Int) async throws -> Data {
        let subjectText = String(subject).lowercased().replacingOccurrences(of: " ", with: "_")
        let limitString = String(limit)
        let offsetString = String(offset)
        guard let url = URL(string: "https://openlibrary.org/subjects/\(subjectText).json?limit=\(limitString)&offset=\(offsetString)") else {
            throw DataError.invalidURL
        }
        print("Info: search request \(url)")
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    

}
