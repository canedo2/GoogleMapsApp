import UIKit
import RxSwift
import GoogleMaps

class MapViewController: BaseViewController {

    //MARK: - UI elements
    private var mapView: GMSMapView!
    
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
            self.view.addSubview(mapView)
            mapView.delegate = self
            isMapInitialized = true
            
            viewModel.output.mapResources.drive { [weak self] resources in
                guard let self = self else { return }
                self.mapView.clear()
                resources.forEach { resource in
                    let coord = CLLocationCoordinate2D(latitude: resource.y, longitude: resource.x)
                    let marker = GMSMarker(position: coord)
                    marker.map = self.mapView
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
