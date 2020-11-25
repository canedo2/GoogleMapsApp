import Foundation
import Moya
import RxMoya
import RxSwift

/**
 Generic struct that exposes an API client for a given `TargetType`.
 */
public struct NetworkRepository<T: TargetType> {
    /// The API client.
    public let apiClient: MoyaProvider<T>

    /// Initializes a new instance of a `NetworkRepository` for a `TargetType`.
    public init(apiClient: MoyaProvider<T> = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])) {
        self.apiClient = apiClient
    }

    /**
     An API resource of the `TargetType` mapped by the `Decodable` type given.
     - Returns: A `Single` trait with an instance of the `Decodable` type given.
     */
    public func resource<C: Decodable>(_ resource: T, mapped: C.Type) -> Single<C> {
        apiClient.rx
            .request(resource)
            .map(mapped)
    }
}
