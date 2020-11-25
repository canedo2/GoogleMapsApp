import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

final class MapViewModel: ViewModelType {
    typealias MapSideCoordinates = (lowerLeftCoordinate: CLLocationCoordinate2D, upperRightCoordinate:CLLocationCoordinate2D)
    
    var input: Input
    var output: Output
    
    private let repository: MapResourcesRepository
    private let bag = DisposeBag()
    
    private let currentMapSidesSubject = PublishSubject<MapSideCoordinates>()
    private let mapResourcesSubject = BehaviorSubject<[MapResource]>(value: [])
    
    struct Input {
        let currentMapSides: AnyObserver<MapSideCoordinates>
    }
    
    struct Output {
        let mapResources: Driver<[MapResource]>
    }
    
    init(mapResourceRepository: MapResourcesRepository) {
        self.repository = mapResourceRepository
        input = Input(currentMapSides: currentMapSidesSubject.asObserver())
        output = Output(mapResources: mapResourcesSubject.asDriver(onErrorJustReturn: []))
        setupRx()
    }
    
    func setupRx() {
        
        currentMapSidesSubject.flatMap { [weak self] coordinates -> Single<[MapResource]> in
            if let lowerLeftLatitude =  Formatters.latLongFormatter.string(from: NSNumber(value: coordinates.lowerLeftCoordinate.latitude)),
               let lowerLeftLongitude = Formatters.latLongFormatter.string(from: NSNumber(value: coordinates.lowerLeftCoordinate.longitude)),
               let upperRightLatitude = Formatters.latLongFormatter.string(from: NSNumber(value: coordinates.upperRightCoordinate.latitude)),
               let upperRightLongitude = Formatters.latLongFormatter.string(from: NSNumber(value: coordinates.upperRightCoordinate.longitude)),
               let self = self {
                return self.repository.resources(lowerLeftLatLon: "\(lowerLeftLatitude),\(lowerLeftLongitude)", upperRightLatLon: "\(upperRightLatitude),\(upperRightLongitude)")
            } else {
                return Single.error(MapResourcesRepository.Error.undefinedError)
            }
        }.subscribe { [weak self] mapResources in
            self?.mapResourcesSubject.onNext(mapResources)
        } onError: { [weak self] error in
            print(error)
            self?.mapResourcesSubject.onError(error)
        }.disposed(by: bag)
        
    }
}
