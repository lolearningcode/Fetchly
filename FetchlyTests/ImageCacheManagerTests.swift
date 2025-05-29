//
//  ImageCacheManagerTests.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//


import XCTest
@testable import Fetchly

final class ImageCacheManagerTests: XCTestCase {
    var cache: ImageCacheManager!
    var testDir: URL!
    
    override func setUp() {
        super.setUp()
        testDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        cache = ImageCacheManager(directory: testDir)
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: testDir)
        super.tearDown()
    }

    func testSaveAndRetrieveImageData() {
        let key = "test_image"
        let data = "12345".data(using: .utf8)!
        
        cache.save(data: data, forKey: key)
        let result = cache.image(forKey: key)
        
        XCTAssertEqual(result, data)
    }

    func testContainsReturnsTrueAfterSaving() {
        let key = "test_image"
        let data = Data([0x01, 0x02, 0x03])
        
        cache.save(data: data, forKey: key)
        XCTAssertTrue(cache.contains(key: key))
    }

    func testContainsReturnsFalseForMissingKey() {
        XCTAssertFalse(cache.contains(key: "nonexistent_key"))
    }

    func testImageReturnsNilForMissingKey() {
        XCTAssertNil(cache.image(forKey: "missing_key"))
    }
}