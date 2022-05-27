//
//  FileLoader.swift
//  WhoppahUI
//
//  Created by Dennis Ippel on 26/04/2022.
//

import Foundation
import Combine

class FileLoader: ObservableObject {
    @Published var url: URL?
    
    private(set) var isLoading = false
    
    private let remoteUrl: URL
    private var cache: FileCache?
    private var cancellable: AnyCancellable?
    
    private static let fileProcessingQueue = DispatchQueue(label: "whoppahui-file-processing")
    
    init(url: URL, cache: FileCache? = nil) {
        self.remoteUrl = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let localUrl = cache?[remoteUrl] {
            self.url = localUrl
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: remoteUrl)
            .tryMap { [weak self] in
                guard let self = self else { return nil }

                let fileName = "\(UUID().uuidString).\(self.remoteUrl.pathExtension)"
                let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                
                try $0.data.write(to: path)
                
                return path
            }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.fileProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.url = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ url: URL?) {
        url.map { cache?[remoteUrl] = $0 }
    }
}
