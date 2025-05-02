//
//  DataError.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/22/25.
//
import Foundation

enum DataError: Error {
    case invalidURL
    case decodingFailed(Error)
    case networkError(Error)
    case unknown
}

struct IdentifiableError: Identifiable {
    let id = UUID()
    let error: Error
}
