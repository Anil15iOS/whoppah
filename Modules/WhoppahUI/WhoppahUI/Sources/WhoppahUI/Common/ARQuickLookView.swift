//
//  ARQuickLookView.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 25/04/2022.
//

import SwiftUI
import QuickLook
import ARKit

class ARQuickLookPreviewController: UIViewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    var url: URL?
    var showARQuickLook = Binding<Bool>(.constant(false))
    
    override func viewDidAppear(_ animated: Bool) {
        let controller = QLPreviewController()
        controller.delegate = self
        controller.dataSource = self
        controller.modalPresentationStyle = .overFullScreen
        
        present(controller, animated: true, completion: nil)
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let previewItem = ARQuickLookPreviewItem(fileAt: url!)
        previewItem.allowsContentScaling = true
        return previewItem
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        showARQuickLook?.wrappedValue = false
    }
}

struct ARQuickLookView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARQuickLookPreviewController
    
    private let url: URL
    @Binding private var showARQuickLook: Bool
    
    init(url: URL,
         showARQuickLook: Binding<Bool>) {
        self.url = url
        self._showARQuickLook = showARQuickLook
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ARQuickLookPreviewController {
        let viewController = ARQuickLookPreviewController()
        viewController.url = url
        viewController.showARQuickLook = $showARQuickLook
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARQuickLookPreviewController, context: Context) {}

    class Coordinator: NSObject {
        var parent: ARQuickLookView
        init(_ parent: ARQuickLookView) {
            self.parent = parent
        }
    }
}
