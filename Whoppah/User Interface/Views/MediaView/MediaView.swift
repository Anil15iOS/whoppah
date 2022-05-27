//
//  MediaView.swift
//  Whoppah
//
//  Created by Boris Sagan on 1/11/19.
//  Copyright © 2019 Whoppah. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit
import WhoppahCore

protocol MediaViewDelegate: AnyObject {
    func mediaViewDidSelect(_ view: MediaView, at index: Int?)
    func videoDidStart(_ view: MediaView)
    func videoDidEnd()
}

@IBDesignable
class MediaView: UIView {
    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var thumbnailView: UIImageView!
    @IBOutlet var scrubberView: UIView!
    @IBOutlet var progressView: UISlider!
    @IBOutlet var progressText: UILabel!
    @IBOutlet var playButton: UIButton!

    // MARK: - Properties

    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    private var cleanupUrl: URL?
    private var statusObserver: NSKeyValueObservation?
    private var thumbTapGesture: UITapGestureRecognizer?

    var videoUrl: URL?

    var isVideo: Bool {
        player != nil
    }

    var isPlaying: Bool {
        if let rate = player?.rate, rate > 0.0 { return true }
        return false
    }

    var isMuted: Bool {
        get {
            player?.isMuted ?? false
        }
        set {
            player?.isMuted = newValue
        }
    }

    // Enables tap to propagate to other views, i.e. in a collection view we may want the cell to receive didSelect calls
    var propogateThumbnailTaps: Bool = false {
        didSet {
            thumbTapGesture?.cancelsTouchesInView = !propogateThumbnailTaps
        }
    }

    override var bounds: CGRect {
        didSet {
            playerLayer?.frame = bounds
        }
    }

    @IBInspectable var isLoop: Bool = false
    @IBInspectable var showControls: Bool = true {
        didSet {
            if !showControls {
                playButton.isVisible = false
                progressText.isVisible = false
                progressView.isVisible = false
                playButton.isVisible = false
            }
        }
    }

    @IBInspectable var showScrubber: Bool = false {
        didSet {
            scrubberView.isVisible = showScrubber && showControls
        }
    }

    weak var delegate: MediaViewDelegate?
    var index: Int?

    enum PlayState {
        case playing
        case stopped
    }

    var resumePlayState: PlayState = .stopped

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        statusObserver = nil
        if let url = cleanupUrl, url.isFileURL {
            try? FileManager.default.removeItem(at: url)
        }
    }

    // MARK: - Common

    private func commonInit() {
        Bundle.main.loadNibNamed("MediaView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true

        thumbnailView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.isUserInteractionEnabled = true
        thumbTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        thumbnailView.addGestureRecognizer(thumbTapGesture!)

        playButton.isVisible = false
        setupProgressText()
        bringSubviewToFront(scrubberView)
    }

    // MARK: - Actions

    @IBAction func playAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            play()
        } else {
            pause()
        }
    }

    @objc func tapHandler(_: UITapGestureRecognizer) {
        if isVideo {
            if isPlaying, player?.error == nil {
                playButton.isVisible = !playButton.isVisible && showControls
                fadeDownPlayButton()
                playButton.isSelected = true
            } else {
                delegate?.mediaViewDidSelect(self, at: index)
                playButton.isSelected = false
            }
        } else {
            delegate?.mediaViewDidSelect(self, at: index)
        }
    }

    @IBAction func sliderValueChanged(slider: UISlider) {
        let duration = playerItemDuration()
        guard duration.isValid else { return }
        let durationToSeek = Float(duration.seconds) * slider.value
        player?.seek(to: CMTimeMakeWithSeconds(Float64(durationToSeek), preferredTimescale: player!.currentItem!.duration.timescale), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }

    // MARK: - Private

    func configure(data: Data) {
        let nsData = data as NSData
        let mediaId = UUID()
        // Need to write synchronously here because other parent views (mostly LightboxImage) require a url for their init
        let result = nsData.writeToURLSynchronous(named: "temporary-\(mediaId.uuidString).mov")
        switch result {
        case let .success(url):
            cleanupUrl = url
            configure(videoUrl: url)
        case .failure:
            break
        }
    }

    func configure(videoUrl: URL) {
        self.videoUrl = videoUrl
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer?.contentsGravity = .center
        isMuted = true // Mute by default
        if let playerLayer = self.playerLayer {
            thumbnailView.layer.addSublayer(playerLayer)
        }

        setupProgressView()
        playButton.isVisible = showControls
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        if let item = player?.currentItem {
            statusObserver = item.observe(\.status, options: [.initial, .new], changeHandler: { [weak self] item, value in
                guard let self = self else { return }
                let status = value.newValue ?? item.status
                switch status {
                case .readyToPlay:
                    if self.isPlaying {
                        self.playButton.isSelected = true
                        self.delegate?.videoDidStart(self)
                    }
                case .failed:
                    break
                default:
                    break
                }
            })
        }
    }

    func play() {
        guard let player = player else { return }
        if player.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            assert(isVideo)
            player.play()
            playButton.isVisible = showControls
            resumePlayState = .playing
            
            if showControls {
                fadeDownPlayButton()
            }
            
            if player.status == .readyToPlay {
                delegate?.videoDidStart(self)
                playButton.isSelected = true
            }
        }
    }

    private func setupProgressText() {
        progressText.text = ""
        progressText.layer.shadowColor = UIColor.black.cgColor
        progressText.layer.shadowOffset = CGSize(width: 0, height: 4)
        progressText.layer.shadowRadius = 16
        progressText.layer.shadowOpacity = 0.1
    }

    private func playerItemDuration() -> CMTime {
        if let playerItem = player?.currentItem, playerItem.status == AVPlayerItem.Status.readyToPlay {
            return playerItem.duration
        }
        return CMTime.invalid
    }

    private func setupProgressView() {
        let playerDuration = playerItemDuration()

        var interval = 0.1
        let duration = playerDuration.seconds
        if !playerDuration.isValid {
            interval = 1.0 / 60.0
        } else if duration.isFinite {
            let width = progressView.bounds.width
            interval = 0.5 * duration / Double(width)
        }

        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] _ in
            self?.updateProgress()
        })
    }

    private func updateProgress() {
        guard let player = player else { return }
        let playerDuration = playerItemDuration()
        if !playerDuration.isValid {
            progressView.value = 0.0
            return
        }
        let duration = playerDuration.seconds
        if duration.isFinite, duration > 0.0 {
            let time = player.currentTime()
            progressView.value = Float(time.seconds) / Float(duration)
            let minsElapsed = Int(round(time.seconds / 60.0))
            let secondsElapsed = Int(time.seconds.remainder(dividingBy: 60.0))

            let minsDuration = Int(round(duration / 60.0))
            let secondsDuration = Int(duration.remainder(dividingBy: 60.0))
            progressText.text = String(format: "%d:%02d | %d:%02d", minsElapsed, secondsElapsed, minsDuration, secondsDuration)
        }
    }

    func pause() {
        if resumePlayState != .stopped {
            player?.pause()
            playButton.isVisible = showControls
            playButton.isSelected = false
        }
    }

    func resume() {
        if resumePlayState == .playing {
            player?.play()
        }
    }

    func stop() {
        assert(isVideo)
        player?.pause()
        player?.seek(to: CMTime.zero)
        resumePlayState = .stopped
        playButton.isVisible = showControls
        playButton.isSelected = false
    }

    @objc func reachTheEndOfTheVideo(_: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        } else {
            stop()
            playButton.isVisible = showControls
            playButton.isSelected = false
            delegate?.videoDidEnd()
            resumePlayState = .stopped
        }
    }

    func setSize(_ size: CGSize) {
        playerLayer?.frame = CGRect(origin: CGPoint.zero, size: size)
        contentView.frame = CGRect(origin: CGPoint.zero, size: size)
    }
    
    private func fadeDownPlayButton() {
        guard playButton.isVisible, showControls else { return }
        let timer = Timer(timeInterval: 3, repeats: false) { [weak self] _ in
            guard let player = self?.player, player.timeControlStatus == .playing else {
                self?.playButton.isVisible = self?.showControls ?? false
                return
            }
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.playButton.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.playButton.isVisible = false
                self?.playButton.alpha = 1.0
            })
        }
        RunLoop.current.add(timer, forMode: .default)
    }
}
