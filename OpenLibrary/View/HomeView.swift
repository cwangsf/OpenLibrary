//
//  ContentView.swift
//  iOSTechTest


import SwiftUI
import SwiftData

// MARK: - BookListView

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.isNetworkConnected) private var isConnected
    @StateObject var searchSubjectViewModel: SearchSubjectViewModel
    @State private var error: Error?
    @State private var searchInput = ""
    @State private var searchTask: Task<Void, Never>?
    
    init() {
        _searchSubjectViewModel = StateObject(wrappedValue: SearchSubjectViewModel())
    }
    
    var body: some View {
        NavigationStack {
            switch searchSubjectViewModel.searchStatus {
            case .initial:
                WelcomeView()              
            case .firstLoading:
                ProgressView("Searching the books...")
                    .frame(maxWidth: .infinity)
            case .loaded:
                BookListView(viewModel: searchSubjectViewModel)
            case .empty:
                EmptyListView(searchText: searchSubjectViewModel.searchText)
            }
            
            #if DEBUG
            Spacer()
            NavigationLink {
                SwiftDataDebugView()
            } label: {
                Label("Debug Database", systemImage: "swiftdata")
                    .font(.caption)
                    .padding()
            }
            #endif
        }
        .task {
            searchSubjectViewModel.modelContext = modelContext
        }
        .searchable(text: $searchInput)
        .onChange(of: searchInput) { oldValue, newValue in
            searchTask?.cancel()
            guard !newValue.isEmpty && newValue.count >= 3 && oldValue != newValue else {
                return
            }
            searchSubjectViewModel.searchText = newValue
            
            searchTask = Task {
                do {
                    try await Task.sleep(for: .milliseconds(500))
                    if !Task.isCancelled {
                        if let isConnected = isConnected, isConnected {
                            await doSearch()
                        } else {
                            doLocalSearch()
                        }
                    }
                } catch is CancellationError {
                    print("INFO: Search cancelled during the sleep time.")
                    return
                } catch {
                    self.error = error
                    print("ERROR: \(error)")
                }
            }
        }
    }
    
    private func doLocalSearch() {
        let subject = searchSubjectViewModel.searchText
        let fetchDescriptor = FetchDescriptor<OfflineSubjectMap>(
            predicate: #Predicate { $0.subject == subject }
        )
        if let offlineMap = try? modelContext.fetch(fetchDescriptor).first {
            searchSubjectViewModel.bookItems = offlineMap.bookItemList
            searchSubjectViewModel.searchStatus = offlineMap.bookItemList.isEmpty ? .empty : .loaded
        } else {
            searchSubjectViewModel.bookItems = []
            searchSubjectViewModel.searchStatus = .empty
        }
    }
    
    private func doSearch() async {
        do {
            try await searchSubjectViewModel.search(subject: searchSubjectViewModel.searchText)
        } catch {
            self.error = error
            print("ERROR: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookItem.self, BookInfo.self, configurations: config)
    
    return HomeView()
        .modelContainer(container)
}






