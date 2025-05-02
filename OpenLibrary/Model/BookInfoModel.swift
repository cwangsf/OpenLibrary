//
//  BookInfoModel.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/27/25.
//
import SwiftData
import Foundation

@Model
class BookInfo: Codable {
    @Attribute(.unique) var key: String // Assume key is unique for every book
    var title: String
    var bookDescription: String
    var authors: [AuthorElement]
    var publishDate: String?
    var coverImageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case bookDescription = "description"
        case authors
        case publishDate = "first_publish_date"
    }
    
    struct DescriptionObject: Decodable {
        let type: String?
        let value: String
    }
    
    init(key: String, title: String, description: String, authors: [AuthorElement], publishDate: String?, coverImageData: Data? = nil) {
        self.key = key
        self.title = title
        self.bookDescription = description
        self.authors = authors
        self.publishDate = publishDate
        self.coverImageData = coverImageData
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)
        authors = try container.decode(Array<AuthorElement>.self, forKey: .authors)
        publishDate = try container.decodeIfPresent(String.self, forKey: .publishDate)
        
        if let desc = try? container.decode(String.self, forKey: .bookDescription) {
            bookDescription = desc
        } else if let descObj = try? container.decode(DescriptionObject.self, forKey: .bookDescription) {
            bookDescription = descObj.value
        } else {
            bookDescription = ""
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(title, forKey: .title)
        try container.encode(bookDescription, forKey: .bookDescription)
        try container.encode(authors, forKey: .authors)
    }
}
