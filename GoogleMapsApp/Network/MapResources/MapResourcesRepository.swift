import Foundation
import Moya
import RxMoya
import RxSwift

typealias MapResourcesRepository = NetworkRepository<MapResourcesService>

extension MapResourcesRepository {
    public enum Error: Swift.Error {
        case undefinedError
    }

    public func resources(lowerLeftLatLon: String, upperRightLatLon: String) -> Single<[MapResource]> {
        apiClient.rx.request(.resources(lowerLeftLatLon: lowerLeftLatLon, upperRightLatLon: upperRightLatLon))
            .debug()
            .flatMap { result -> Single<[MapResource]> in
                do {
                    let resources = try JSONDecoder().decode([MapResource].self, from: result.data)
                    return .just(resources)
                } catch {
                    return .error(Self.Error.undefinedError)
                }
            }
    }
}
