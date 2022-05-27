//
//  AdLocationViewController.swift
//  Whoppah
//
//  Created by Boris Sagan on 3/22/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import MapKit
import UIKit
import WhoppahCore

class AdLocationViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var navigationBar: NavigationBar!
    @IBOutlet var mapView: MKMapView!

    // MARK: - Properties

    var ad: ProductDetails?

    // MARK: - ViewController's Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        setUpMapView()
    }

    // MARK: - Private

    private func setUpNavigationBar() {
        navigationBar.titleLabel.text = ad?.title
        navigationBar.backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
    }

    private func setUpMapView() {
        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.register(AdAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AdAnnotationView")

        let annotation = AdAnnotation()
        annotation.adDetails = ad
        if let coordinate = ad?.location?.point {
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 3000)
            mapView.setRegion(region, animated: true)

            annotation.adCoordinate = center
            mapView.addAnnotation(annotation)
        }
    }

    // MARK: - Actions

    @objc func backAction(_: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension AdLocationViewController: MKMapViewDelegate {
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

        if let ad = annotation.adDetails {
            Navigator().navigate(route: Navigator.Route.ad(id: ad.id))
        } else if let ad = annotation.ad {
            Navigator().navigate(route: Navigator.Route.ad(id: ad.id))
        }
    }
}
