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


}
