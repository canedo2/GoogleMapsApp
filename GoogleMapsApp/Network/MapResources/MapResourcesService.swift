import Foundation
import Moya
import RxSwift

public enum MapResourcesService {
    case resources(lowerLeftLatLon: String, upperRightLatLon: String)
}

extension MapResourcesService: TargetType {
    public var baseURL: URL { URL(string: endpoint)! }

    public var path: String {
        switch self {
        case .resources:
            return "/lisboa/resources"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .resources:
            return .get
        }
    }

    public var sampleData: Data {
        Data()
    }

    public var task: Task {
        switch self {
        case let .resources(lowerLeftLatLon, upperRightLatLon):
            var parameters = [String: String]()
            parameters["lowerLeftLatLon"] = lowerLeftLatLon
            parameters["upperRightLatLon"] = upperRightLatLon
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return nil
    }

    private var endpoint: String {
        return "https://apidev.meep.me/tripplan/api/v1/routers"
    }
}
