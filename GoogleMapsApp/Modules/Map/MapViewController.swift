import UIKit
import RxSwift
import GoogleMaps

class MapViewController: BaseViewController {

    typealias MapResourceId = String
    
    //MARK: - UI elements
    private var mapView: GMSMapView!
    private var mapMarkersRegister = [MapResourceId:GMSMarker]()
    
    //MARK: - Control
    private var isMapInitialized = false
    private var lowerLeft = CLLocationCoordinate2D(latitude: 38.711046, longitude: -9.160096)
    private var upperRight = CLLocationCoordinate2D(latitude: 38.739429, longitude: -9.137115)
    
    private let viewModel = MapViewModel(mapResourceRepository: MapResourcesRepository())
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapIfNeeded()
    }

    
    private func setupMapIfNeeded() {
        if !isMapInitialized {
            mapView = GMSMapView(frame: self.view.bounds)
            mapView.setMinZoom(14, maxZoom: 20)
            self.view.addSubview(mapView)
            mapView.delegate = self
            isMapInitialized = true
            
            viewModel.output.mapResources.drive { [weak self] resources in
                guard let self = self else { return }
                //Clear old markers
                let newResourcesIds = resources.map { resource -> MapResourceId in resource.id }
                self.mapMarkersRegister.forEach { (key: MapResourceId, value: GMSMarker) in
                    if !newResourcesIds.contains(key), let marker = self.mapMarkersRegister[key] {
                        marker.map = nil
                        self.mapMarkersRegister.removeValue(forKey: key)
                    }
                }
                //Add new markers
                resources.forEach { resource in
                    if !self.mapMarkersRegister.keys.contains(resource.id) {
                        let coord = CLLocationCoordinate2D(latitude: resource.y, longitude: resource.x)
                        let marker = GMSMarker(position: coord)
                        marker.icon = GMSMarker.markerImage(with: ZoneIdToColorTransformer.transformToColor(zoneId: resource.companyZoneId))
                        marker.title = resource.name
                        marker.map = self.mapView
                        self.mapMarkersRegister[resource.id] = marker
                    }
                }
            }.disposed(by:bag)
        }
        
        let bounds = GMSCoordinateBounds(coordinate: lowerLeft, coordinate: upperRight)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 0.0)
        
        mapView.moveCamera(update)
    }

}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let lowerLeft = mapView.projection.coordinate(for: CGPoint(x: mapView.bounds.minX, y: mapView.bounds.maxY))
        let upperRight = mapView.projection.coordinate(for: CGPoint(x: mapView.bounds.maxX, y: mapView.bounds.minY))
        viewModel.input.currentMapSides.onNext((lowerLeftCoordinate: lowerLeft, upperRightCoordinate: upperRight))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false //Default delection behaviour
    }
}
