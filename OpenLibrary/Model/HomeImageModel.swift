//
//  ImageModel.swift
//  OpenLibrary
//
//  Created by Cynthia Wang on 5/24/25.
//
import Foundation

struct HomeImageModel: Identifiable {
    var id: String = UUID().uuidString
    var quote: QuoteModel
    var image: String
}

struct QuoteModel: Identifiable {
    var id: String = UUID().uuidString
    var quoteText: String
    var author: String
}
