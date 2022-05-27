//
//  MapSearchViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/21/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MapKit
import RxSwift
import UIKit
import WhoppahCore
import WhoppahCoreNext
import Resolver

class MapSearchViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var searchField: SearchField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterCountView: UIView!
    @IBOutlet var filterCountLabel: UILabel!
    @IBOutlet var searchPin: UIImageView!
    @IBOutlet var searchLocationLabel: UILabel!

    var viewModel: MapSearchViewModel!
    private let bag = DisposeBag()

    var bottomSheetVC: BottomSheetAdsViewController!

    @Injected private var searchService: SearchService
    
    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(applyFiltersAction(_:)), name: FiltersViewModel.NotificationName.didApplyFilters, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetFiltersAction(_:)), name: FiltersViewModel.NotificationName.didResetFilters, object: nil)

        setUpMapView()
        setUpSearchField()
        setUpButtons()
        setUpViewModel()
        setUpBottomSheet()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addBottomSheet()
    }

    // MARK: - Private

    private func setUpViewModel() {
        viewModel.outputs.searchLocationLabel.bind(to: searchLocationLabel.rx.text).disposed(by: bag)

        viewModel.outputs.region.compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] region in
                self?.mapView.setRegion(region, animated: true)
            }).disposed(by: bag)

        viewModel.outputs.adVMs
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] ads in
                self?.bottomSheetVC?.ads = ads
            }).disposed(by: bag)

        viewModel.outputs.filterCount.bind(to: filterCountLabel.rx.text).disposed(by: bag)

        viewModel.outputs.ads
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] ads in
                guard let self = self else { return }
                if !self.mapView.annotations.isEmpty {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                }
                self.mapView.addAnnotations(ads)

                if ads.isEmpty {
                    let dialog = NoMapSearchResultsDialog()
                    dialog.onFiltersSelected = {
                        self.showFilters()
                    }
                    self.present(dialog, animated: true, completion: nil)
                }
            }).disposed(by: bag)
    }

    private func setUpBottomSheet() {
        bottomSheetVC = UIStoryboard(storyboard: .search).instantiateViewController()
    }

    private func setUpMapView() {
        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.register(AdAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AdAnnotationView")
        searchPin.alpha = 0.0
        searchLocationLabel.alpha = 0.0

        searchPin.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pinAction(_:)))
        searchPin.addGestureRecognizer(tap)

        viewModel.outputs.searching
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] searching in
                if searching {
                    self?.startMapSearching()
                } else {
                    self?.stopMapSearching()
                }
            }).disposed(by: bag)
    }

    private func setUpButtons() {
        filterButton.backgroundColor = .white
        filterButton.layer.cornerRadius = filterButton.bounds.height / 2
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOpacity = 0.1
        filterButton.layer.shadowRadius = 16.0
        filterButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)

        filterCountView.layer.cornerRadius = filterCountView.bounds.height / 2
    }

    private func setUpSearchField() {
        searchField.delegate = self
        searchField.textField.text = searchService.searchText
    }

    private func startMapSearching() {
        UIView.animate(withDuration: 0.3) {
            self.filterCountView.alpha = 0.0
            self.filterButton.alpha = 0.0
            self.searchPin.alpha = 1.0
            self.searchLocationLabel.alpha = 1.0
        }
    }

    private func stopMapSearching() {
        UIView.animate(withDuration: 0.3) {
            self.filterCountView.alpha = 1.0
            self.filterButton.alpha = 1.0
            self.searchPin.alpha = 0.0
            self.searchLocationLabel.alpha = 0.0
        }
    }

    private func addBottomSheet() {
        guard bottomSheetVC.parent == nil else { return }

        // 2- Add bottomSheetVC as a child view
        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width = view.frame.width

        let window = UIApplication.shared.keyWindow!
        let bottomPadding = window.safeAreaInsets.bottom
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.maxY + bottomPadding, width: width, height: height)
    }

    private func showFilters() {
        viewModel.showFilters()
    }

    // MARK: - Actions

    @IBAction func backAction(_: UIButton) {
        viewModel.backPressed()
    }

    @IBAction func filterAction(_: UIButton) {
        showFilters()
    }

    @objc func pinAction(_: UITapGestureRecognizer) {
        let edge = CGPoint(x: mapView.bounds.origin.x, y: (mapView.bounds.origin.y + mapView.bounds.size.height) / 2)
        let edgeCoordinate = mapView.convert(edge, toCoordinateFrom: mapView)
        let edgeLocation = CLLocation(latitude: edgeCoordinate.latitude, longitude: edgeCoordinate.longitude)
        viewModel.pinItem(edgeLocation: edgeLocation)
    }

    @objc func applyFiltersAction(_: Notification) {
        viewModel.applyFilters()
    }

    @objc func resetFiltersAction(_: Notification) {
        viewModel.resetFilters()
    }
}

// MARK: - MKMapViewDelegate

extension MapSearchViewController: MKMapViewDelegate {
    func mapView(_: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !animated {
            startMapSearching()
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated _: Bool) {
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        viewModel.regionDidChange(clLocation: location)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AdAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AdAnnotationView") as? AdAnnotationView

        if annotationView == nil {
            annotationView = AdAnnotationView(annotation: annotation, reuseIdentifier: "AdAnnotationView")
        } else {
            annotationView!.annotation = annotation
        }

        if let ad = annotation.adDetails {
            annotationView?.priceLabel.text = ad.price?.formattedPrice()
            let url = URL(string: ad.previewImages.first?.url ?? "")
            annotationView?.imageView.setImage(forUrl: url)
        } else if let ad = annotation.ad {
            annotationView?.priceLabel.text = ad.price?.formattedPrice()
            annotationView?.imageView.setImage(forUrl: ad.image.first?.asURL())
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        guard let annotation = view.annotation as? AdAnnotation else { return }
        viewModel.didSelect(annotation: annotation)
    }
}

// MARK: - SearchFieldDelegate

extension MapSearchViewController: SearchFieldDelegate {
    func searchFieldDidClickCamera(_: SearchField) {}

    func searchFieldDidReturn(_ searchField: SearchField) {
        searchField.textField.resignFirstResponder()
        viewModel.inputs.searchText.onNext(searchField.text)
    }

    func searchFieldDidBeginEditing(_: SearchField) {}

    func searchField(_: SearchField, didChangeText _: String) {}
}
