//
//  BookItem.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/22/25.
//
import SwiftData
import Foundation

struct AuthorElement: Codable {
    let author: AuthorInfo
}

struct AuthorInfo: Codable {
    let name: String?
    let key: String // Sample: https://openlibrary.org/authors/OL23919A.json
    
    static let emilyBronte = AuthorInfo(name: "Emily Brontë", key: "/authors/OL24529A")
    static let scotFitzgerald = AuthorInfo(name: "F. Scott Fitzgerald", key: "/authors/OL27349A")
    static let edithWharton = AuthorInfo(name: "Edith Wharton", key: "/authors/OL20188A")
    static let shakespeare = AuthorInfo(name: "William Shakespeare", key: "/authors/OL9388A")
}

@Model
class BookItem: Codable, Hashable {
    @Attribute(.unique) var key: String
    var title: String
    var authors: [AuthorInfo] //This authors and the single book return "authors" seems has different json structure
    var coverid: Int?
    var coverImageData: Data?
    
    var authorNames: String {
        authors.compactMap{ $0.name }.joined(separator: ", ")
    }
    
    init(key: String, title: String, authors: [AuthorInfo], coverid: Int? = nil, coverImageData: Data? = nil) {
        self.key = key
        self.title = title
        self.authors = authors
        self.coverid = coverid
        self.coverImageData = coverImageData
    }

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authors
        case coverid = "cover_id"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)
        authors = try container.decode([AuthorInfo].self, forKey: .authors)
        coverid = try container.decode(Int?.self, forKey: .coverid)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authors)
        try container.encodeIfPresent(coverid, forKey: .coverid)
    }
    
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        return lhs.key == rhs.key
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static let sampleBookItems = [
        BookItem(key: "/works/OL21177W",
                 title: "Wuthering Heights",
                 authors: [AuthorInfo.emilyBronte],
                 coverid: 8303480),
        BookItem(key: "/works/OL468431W",
                 title: "The Great Gatsby",
                 authors: [AuthorInfo.scotFitzgerald],
                 coverid: 8303480),
        BookItem(key: "/works/OL98501W",
                 title: "Ethan Frome",
                 authors: [AuthorInfo.edithWharton],
                 coverid: 8303480),
        BookItem(key: "/works/OL362427W",
                 title: "Romeo and Juliet",
                 authors: [AuthorInfo.shakespeare],
                 coverid: 8303480)
    ]
}

