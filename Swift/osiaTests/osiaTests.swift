//
//  osiaTests.swift
//  osiaTests
//
//  Created by Daniel on 5/4/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import XCTest

@testable import osia

class osiaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppIsArchive() throws {
        // Given
        var a = App()

        // When
        a.tags = ["archive"]

        // Then
        XCTAssertTrue(a.isArchived)
    }

    func testAppIsNotArchive() throws {
        // Given
        let a = App()

        // Then
        XCTAssertTrue(a.isArchived == false)
    }

    func testCategoryIsNotParent() throws {
        // Given
        var c = Category()

        // When
        c.parent = "test"

        // Then
        XCTAssertTrue(c.isParent == false)
    }

    func testCategoryIsParent() throws {
        // Given
        let c = Category()

        // Then
        XCTAssertTrue(c.isParent)
    }

    func testCategoryListCountWhenEmpty() throws {
        // Given
        let c = Category()

        // Then
        XCTAssertTrue(c.list.count == 0)
    }

    func testCategoryListAppsCount() throws {
        // Given
        var c = Category()

        // When
        c.apps = [App()]

        // Then
        XCTAssertTrue(c.list.count == 1)
    }

    func testCategoryListCategoriesCount() throws {
        // Given
        var c = Category()

        // When
        c.categories = [Category()]

        // Then
        XCTAssertTrue(c.list.count == 1)
    }

    func testCategoryListCount() throws {
        // Given
        var c = Category()

        // When
        c.categories = [Category()]
        c.apps = [App(), App()]

        // Then
        XCTAssertTrue(c.list.count == 3)
    }

    func testCategoryListCountDisplay() throws {
        // Given
        var c = Category()

        // When
        c.categories = [Category()]
        c.apps = [App(), App()]

        // Then
        XCTAssertTrue(c.countDisplay == "3")
    }

    func testDateFormat1() throws {
        // Given
        var a = App()

        // When
        a.dateAdded = "Mar 21, 2019"

        // Then
        XCTAssertTrue(a.dateDisplay == "2019")
    }

    func testDateFormat2() throws {
        // Given
        var a = App()

        // When
        a.dateAdded = "Fri Nov 6 06:19:26 2015 -0800"

        // Then
        XCTAssertTrue(a.dateDisplay == "2015")
    }

    func testDateFormat3() throws {
        // Given
        var a = App()

        // When
        a.dateAdded = "May 4 2020"

        // Then
        XCTAssertTrue(a.dateDisplay == "2020")
    }

    func testDateFormat4() throws {
        // Given
        var a = App()

        // When
        a.dateAdded = "Tue, 17 Mar 2015 14:51:44 -0400"

        // Then
        XCTAssertTrue(a.dateDisplay == "2015")
    }
}
