//
//  MediaReviewViewController.swift
//  Whoppah
//
//  Created by Eddie Long on 09/04/2019.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import UIKit

protocol MediaReviewDelegate: AnyObject {
    func photoDeleted(_ photo: AdPhoto, atPath: IndexPath?)
    func photoAccepted(_ photo: AdPhoto, atPath: IndexPath?)
    func videoDeleted(_ video: AdVideo)
    func videoAccepted(_ video: AdVideo)
}

class MediaReviewViewController: UIViewController {
    var photo: AdPhoto?
    var photoIndexPath: IndexPath?
    var video: AdVideo?
    var videoFileUrl: URL?
    private var mediaView: MediaView?

    // MARK: Outlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mediaViewContainer: UIView!

    weak var delegate: MediaReviewDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let video = video {
            if mediaView == nil {
                let newMediaView = ViewFactory.createMediaView()
                mediaViewContainer.addSubview(newMediaView)
                mediaViewContainer.isVisible = true
                newMediaView.pinToAllEdges(of: mediaViewContainer)
                mediaView = newMediaView

                // Try the local file first - then the remote
                let url = videoFileUrl ?? video.url()
                if let url = url {
                    newMediaView.configure(videoUrl: url)
                    newMediaView.showScrubber = true
                    newMediaView.play()
                } else if let data = video.data() {
                    writeDataToDisk(data: data as NSData)
                }
            }
        } else if let photo = photo, let image = photo.image() {
            imageView.image = image
            imageView.isVisible = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let mediaView = mediaView {
            mediaView.setSize(mediaViewContainer.bounds.size)
        }
    }

    private func writeDataToDisk(data: NSData) {
        data.writeToURL(named: "preview_video.mov") { [weak self] result in
            _ = data // Stop release
            switch result {
            case let .success(url):
                DispatchQueue.main.async {
                    self?.mediaView?.configure(videoUrl: url)
                    self?.mediaView?.play()
                }
            case let .failure(error):
                self?.showErrorDialog(message: R.string.localizable.create_ad_camera_mediareview_unable_load_video(error.localizedDescription))
            }
        }
    }

    // MARK: Actions

    @IBAction func donePressed(_: UIButton) {
        dismiss(animated: true) {
            if self.video != nil {
                self.delegate?.videoAccepted(self.video!)
            } else if self.photo != nil {
                self.delegate?.photoAccepted(self.photo!, atPath: self.photoIndexPath)
            }
        }
    }

    @IBAction func trashPressed(_: UIButton) {
        if video != nil {
            delegate?.videoDeleted(video!)
        } else if photo != nil {
            delegate?.photoDeleted(photo!, atPath: photoIndexPath)
        }

        dismiss(animated: true, completion: nil)
    }
}
