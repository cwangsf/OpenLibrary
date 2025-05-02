//
//  SwiftDataDebugView.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/25/25.
//

import SwiftUI
import SwiftData

struct SwiftDataDebugView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \BookItem.title) var books: [BookItem]
    @Query(sort: \BookInfo.title) var bookInfos: [BookInfo]
    @Query(sort: \OfflineSubjectMap.subject) var offlineSubjects: [OfflineSubjectMap]
    
    var body: some View {
        List {
            // Offline Subjects Section
            Section("Offline Cached Subjects: \(offlineSubjects.count)") {
                ForEach(offlineSubjects, id: \.subject) { subject in
                    DisclosureGroup {
                        ForEach(subject.bookItemList, id: \.key) { book in
                            DebugBookItemView(book: book)
                        }
                    } label: {
                        SubjectHeaderView(subject: subject)
                    }
                }
            }
            
            // Books Section
            Section("Books: \(books.count)") {
                ForEach(books, id: \.key) { book in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title).bold()
                        Text("by \(book.authorNames)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let coverId = book.coverid {
                            Text("Cover ID: \(coverId)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Text("Key: \(book.key)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Book Infos Section
            Section("Book Infos: \(bookInfos.count)") {
                ForEach(bookInfos, id: \.key) { info in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(info.title).bold()
                        if let date = info.publishDate {
                            Text("Published: \(date)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text("Description: \(String(info.bookDescription.prefix(100)))...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Key: \(info.key)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("SwiftData Debug")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear All", role: .destructive) {
                    clearAllData()
                }
            }
        }
    }
    
    private func clearAllData() {
        offlineSubjects.forEach { modelContext.delete($0) }
        books.forEach { modelContext.delete($0) }
        bookInfos.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }
}

struct DebugBookItemView: View {
    let book: BookItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title).bold()
            Text("by \(book.authorNames)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct SubjectHeaderView: View {
    let subject: OfflineSubjectMap
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(subject.subject).bold()
            Text("Cached Books: \(subject.bookItemList.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookItem.self, BookInfo.self, OfflineSubjectMap.self, configurations: config)
    
    let context = container.mainContext
    BookItem.sampleBookItems.forEach { context.insert($0) }
    
    let sampleOfflineMap = OfflineSubjectMap(
        subject: "fiction",
        bookItemList: Array(BookItem.sampleBookItems.prefix(2))
    )
    context.insert(sampleOfflineMap)
    
    let sampleOfflineMap2 = OfflineSubjectMap(
        subject: "romance",
        bookItemList: Array(BookItem.sampleBookItems.suffix(2))
    )
    context.insert(sampleOfflineMap2)
    
    return NavigationStack {
        SwiftDataDebugView()
    }
    .modelContainer(container)
} 
