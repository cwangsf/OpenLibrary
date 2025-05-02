//
//  SearchSubjectResponse.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/22/25.
//

struct SearchSubjectResponse: Codable {
    let numFound: Int
    let key: String
    let books: [BookItem]

    enum CodingKeys: String, CodingKey {
        case numFound = "work_count"
        case key
        case books = "works"
    }
}
