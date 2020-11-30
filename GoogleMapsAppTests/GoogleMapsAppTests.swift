import XCTest
@testable import GoogleMapsApp

class GoogleMapsAppTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testDifferentIdsGenerateDifferentColors() throws {
        
        var results = [String]()
        for id in 0...1999 {
            let color = ZoneIdToColorTransformer.transformToColor(zoneId: id)
            results.append("\(String(describing: color.cgColor.components))")
        }
        
        let unrepeatedArray = Set(results)
        XCTAssertTrue(results.count == unrepeatedArray.count, "\(results.count) vs \(unrepeatedArray.count)")
    }
    
    
    func testParseMapResourcesFromApi() throws {
        let bundle = Bundle(for: type(of: self))
        if let fileUrl = bundle.url(forResource: "test", withExtension: "json") {
            let data = try Data(contentsOf: fileUrl)
            let mapResources = try JSONDecoder().decode([MapResource].self, from: data)
            
            XCTAssertTrue(mapResources.count == 301)
            
            XCTAssertTrue(mapResources[0].id == "402:11059006")
            XCTAssertTrue(mapResources[0].name == "Rossio")
            XCTAssertTrue(mapResources[0].x == -9.1424)
            XCTAssertTrue(mapResources[0].y == 38.71497)
            XCTAssertTrue(mapResources[0].companyZoneId == 402)
            
            XCTAssertTrue(mapResources[300].id == "222")
            XCTAssertTrue(mapResources[300].name == "222 - Praça da Figueira")
            XCTAssertTrue(mapResources[300].x == -9.13828)
            XCTAssertTrue(mapResources[300].y == 38.71383)
            XCTAssertTrue(mapResources[300].companyZoneId == 412)
            
        } else {
            XCTFail("Unable to find json file for test")
        }
    }


}
