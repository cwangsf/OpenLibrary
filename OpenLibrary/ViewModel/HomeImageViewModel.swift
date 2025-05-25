//
//  HomeImageViewModel.swift
//  OpenLibrary
//
//  Created by Cynthia Wang on 5/24/25.
//

struct HomeImageViewModel {
    static let sampleImages: [HomeImageModel] = [
        .init(quote: Self.quotes[0], image: "image1"),
        .init(quote: Self.quotes[1], image: "image2"),
        .init(quote: Self.quotes[2], image: "image3"),
        .init(quote: Self.quotes[3], image: "image4")
    ]
    
    static let quotes: [QuoteModel] = [
        .init(quoteText: "“I have always imagined that Paradise will be a kind of library.”", author: "Jorge Luis Borges"),
        .init(quoteText: "Outside of a dog, a book is a man’s best friend. Inside of a dog, it’s too dark to read.", author: "Groucho Marx"),
        .init(quoteText: "I’m not addicted to reading. I can stop as soon as I finish just one more chapter… or ten.", author: "Anonymous"),
        .init(quoteText: "Some people go to priests; others to poetry; I to my friends.", author: "Virginia Woolf")
    ]
        
}
