//
//  MapSearchViewModel.swift
//  Whoppah
//
//  Created by Eddie Long on 09/09/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import WhoppahCore
import WhoppahDataStore
import Resolver

let defaultLatitude: Double = 52.354486
let defaultLongitude: Double = 4.895188

class MapSearchViewModel {
    struct Inputs {
        let searchText = PublishSubject<String>()
    }

    struct Outputs {
        let adVMs = PublishSubject<[AdViewModel]>()
        var ads: Observable<[AdAnnotation]> {
            _ads.skip(1).asObservable()
        }

        fileprivate let _ads = BehaviorRelay<[AdAnnotation]>(value: [])
        var filterCount: Observable<String> {
            _filterCount.asObservable()
        }

        fileprivate let _filterCount = BehaviorRelay<String>(value: "")

        let error = PublishSubject<Error>()
        let searchLocationLabel = PublishSubject<String>()
        var searching: Observable<Bool> {
            _searching.asObservable()
        }

        fileprivate let _searching = PublishRelay<Bool>()

        var region: Observable<MKCoordinateRegion?>
    }

    let inputs = Inputs()
    var outputs: Outputs!
    
    @Injected private var search: SearchService
    @Injected private var location: LocationService

    private var _center = CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude)
    // Notifies out to the map view
    private let _centerRegion = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude))
    var removeFiltersOnDismiss = true

    private var query: GraphQL.SearchQuery.Data?
    private let repo: LegacySearchRepository
    private let coordinator: MapSearchCoordinator
    private let bag = DisposeBag()
    private var centerPostalCode: String?

    init(repo: LegacySearchRepository,
         coordinator: MapSearchCoordinator,
         latitude _: Double?,
         longitude _: Double?) {
        self.coordinator = coordinator
        self.repo = repo

        let region = _centerRegion.asObservable().map { [weak self] (coordinate) -> MKCoordinateRegion? in
            guard let self = self else { return nil }
            if let radius = self.search.radiusKilometres {
                return MKCoordinateRegion(center: coordinate,
                                          latitudinalMeters: CLLocationDistance(radius * radius),
                                          longitudinalMeters: CLLocationDistance(radius * radius))
            } else {
                return MKCoordinateRegion(center: coordinate,
                                          latitudinalMeters: CLLocationDistance(defaultRadiusKm * defaultRadiusKm),
                                          longitudinalMeters: CLLocationDistance(defaultRadiusKm * defaultRadiusKm))
            }
        }
        outputs = Outputs(region: region)

        repo.data.subscribe(onNext: { [weak self] query in
            self?.outputs._searching.accept(false)
            self?.query = query
        }).disposed(by: bag)

        repo.items.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
            // REMOVED to reduce load on the server
            // We may want to re-instate under a different query later
            /* let adsWithLocation = [] // ads.filter({ $0.point != nil })
             let ads = adsWithLocation.sorted(by: { $0.point!.longitude < $1.point!.longitude })
             var annotations = [AdAnnotation]()
             for ad in ads {
                 let annotation = AdAnnotation()
                 annotation.ad = ad.product
                 annotation.adCoordinate = CLLocationCoordinate2D(latitude: ad.point!.latitude, longitude: ad.point!.longitude)
                 annotations.append(annotation)
             }
             self.outputs._filterCount.accept("\(search.filtersCount)")
             self.outputs.adVMs.onNext(ads)
             self.outputs._ads.accept(annotations) */
            case let .failure(error):
                self.outputs._ads.accept([])
                self.coordinator.showError(error)
            }
        }, onError: { [weak self] error in
            self?.coordinator.showError(error)
        }).disposed(by: bag)

        inputs.searchText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.search.searchText = text
            self.reloadAds()
        }).disposed(by: bag)

        reloadAds()
    }

    private func reloadAds() {
        outputs._searching.accept(true)
        outputs._filterCount.accept("\(search.filtersCount)")

        var filter = search.filterInput
        filter.location = GraphQL.LocationSearchFilterInput(latitude: _center.latitude, longitude: _center.longitude, address: nil, distance: search.radiusKilometres)
        repo.load(query: nil, filter: filter, sort: .distance, ordering: .asc)
    }

    func regionDidChange(clLocation: CLLocation) {
        _center = clLocation.coordinate
        let coordinate = clLocation.coordinate
        location.address(by: clLocation) { [weak self] _, placemark, error in
            guard let self = self else { return }
            let newCoord = self._center
            // Ignore if the coordinate has changed
            guard coordinate.latitude.isApproxEqual(newCoord.latitude),
                coordinate.longitude.isApproxEqual(newCoord.longitude) else { return }
            if error != nil {
                self.outputs.searchLocationLabel.onNext(R.string.localizable.search_map_btn_refresh_empty())
            } else {
                if let postalCode = placemark?.postalCode {
                    self.centerPostalCode = postalCode
                    self.outputs.searchLocationLabel.onNext(R.string.localizable.search_map_btn_refresh(postalCode))
                } else {
                    self.outputs.searchLocationLabel.onNext(R.string.localizable.search_map_btn_refresh_empty())
                }
            }
        }
    }

    // MARK: Actions

    func backPressed() {
        if removeFiltersOnDismiss {
            search.removeAllFilters()
        }
        coordinator.dismiss()
    }

    func showFilters() {
        guard let query = query else { return }
        coordinator.showFilters(query: query)
    }

    func resetFilters() {
        search.removeAllFilters()
        outputs._filterCount.accept("\(search.filtersCount)")
        reloadAds()
    }

    func applyFilters() {
        if let address = search.address {
            if let point = address.point {
                _center = CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
                _centerRegion.accept(_center)
            }
        }
        outputs._filterCount.accept("\(search.filtersCount)")
    }

    func pinItem(edgeLocation: CLLocation) {
        guard let postcode = centerPostalCode else { return }
        let centerLocation = CLLocation(latitude: _center.latitude, longitude: _center.longitude)
        let radiusMetres = edgeLocation.distance(from: centerLocation)

        let newAddress = LegacyAddressInput(line1: "",
                                      line2: "",
                                      postalCode: postcode,
                                      city: "",
                                      state: nil,
                                      country: "",
                                      point: PointInput(latitude: _center.latitude, longitude: _center.longitude))
        search.address = newAddress
        search.radiusKilometres = Int(Float(radiusMetres) / 1000)
        reloadAds()
    }
}

extension MapSearchViewModel {
    func didSelect(annotation: AdAnnotation) {
        if let ad = annotation.adDetails {
            coordinator.openAd(id: ad.id)
        } else if let ad = annotation.ad {
            coordinator.openAd(id: ad.id)
        }
    }
}
