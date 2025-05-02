//
//  OfflineData.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/25/25.
//

import SwiftData
import Foundation

@Model
final class OfflineSubjectMap {
    var subject: String
    @Relationship(deleteRule: .cascade)
    var bookItemList: [BookItem]
    
    init(subject: String, bookItemList: [BookItem], lastUpdated: Date = Date()) {
        self.subject = subject
        self.bookItemList = bookItemList
    }
}
