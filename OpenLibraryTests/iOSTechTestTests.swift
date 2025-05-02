//
//  iOSTechTestTests.swift
//  iOSTechTestTests
//
//  Created by Stone Zhang on 2023/11/26.
//

import XCTest
@testable import iOSTechTest

final class iOSTechTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchSubjectViewModelInitialState() {
        let viewModel = SearchSubjectViewModel()
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.bookItems.count, 0)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.searchStatus, .initial)
    }
    
    
    func testBookItemDecoding() throws {
        let json = """
            {
                "key": "/works/OL21177W",
                "title": "Wuthering Heights",
                "edition_count": 2850,
                "cover_id": 12818862,
                "lending_identifier": "wutheringheights0000kesh",
                "authors": [
                    {
                    "key": "/authors/OL24529A",
                    "name": "Emily Brontë"
                    }
                ]
            }
            """
        let data = Data(json.utf8)
        let bookItem = try JSONDecoder().decode(BookItem.self, from: data)
        XCTAssertEqual(bookItem.key, "/works/OL21177W")
        XCTAssertEqual(bookItem.title, "Wuthering Heights")
        XCTAssertEqual(bookItem.authorNames, "Emily Brontë")
        XCTAssertEqual(bookItem.coverid, 12818862)
    }
    
    func testBookInfoDecodingFormat1() throws {
        let json = """
        {
            "first_publish_date": "1949",
            "key": "/works/OL362427W",
            "title": "Romeo and Juliet",
            "description": "A love story.",
            "authors": [
                {
                    "author": {
                        "key": "/authors/OL9388A"
                    },
                    "type": {
                        "key": "/type/author_role"
                    }
                }
            ]
        }
        """
        let data = Data(json.utf8)
        let bookInfo = try JSONDecoder().decode(BookInfo.self, from: data)
        XCTAssertEqual(bookInfo.key, "/works/OL362427W")
        XCTAssertEqual(bookInfo.title, "Romeo and Juliet")
        XCTAssertEqual(bookInfo.publishDate, "1949")
    }
    
    func testBookInfoDecodingFormat1WithoutOptionalProperty() throws {
        let json = """
        {
            "key": "/works/OL362427W",
            "title": "Romeo and Juliet",
            "description": "A love story.",
            "authors": [
                {
                    "author": {
                        "key": "/authors/OL9388A"
                    },
                    "type": {
                        "key": "/type/author_role"
                    }
                }
            ]
        }
        """
        let data = Data(json.utf8)
        let bookInfo = try JSONDecoder().decode(BookInfo.self, from: data)
        XCTAssertEqual(bookInfo.key, "/works/OL362427W")
        XCTAssertEqual(bookInfo.title, "Romeo and Juliet")
        XCTAssertEqual(bookInfo.bookDescription, "A love story.")
    }
    
    func testBookInfoDecodingFormat2() throws {
        let json = """
        {
            "key": "/works/OL21177W",
            "title": "Wuthering Heights",
            "first_publish_date": "1847",
            "description": {
                "type": "/type/text",
                "value": "A classic novel of love and revenge."
            },
            "authors": [
                {
                    "author": {
                        "key": "/authors/OL24529A"
                    },
                    "type": {
                        "key": "/type/author_role"
                    }
                }
            ]
        }
        """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()

        let bookInfo = try decoder.decode(BookInfo.self, from: data)
        XCTAssertEqual(bookInfo.key, "/works/OL21177W")
        XCTAssertEqual(bookInfo.title, "Wuthering Heights")
        XCTAssertEqual(bookInfo.publishDate, "1847")
        XCTAssertEqual(bookInfo.bookDescription, "A classic novel of love and revenge.")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
