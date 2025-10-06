import Foundation
import Observation
import Nuke
import Dependencies
import CoreKit

@Observable
public final class MVVMLoaderViewModel {
    public struct ImageState {
        public var image: PlatformImage?
        public var isLoading: Bool
    }

    @ObservationIgnored
    private let pipeline: ImagePipeline
    @ObservationIgnored
    @Dependency(\.logger) private var logger

    public private(set) var imageState = ImageState(image: nil, isLoading: false)
    public let imageURL: URL?

    public init(imageURL: URL?, pipeline: ImagePipeline = .shared) {
        self.imageURL = imageURL
        self.pipeline = pipeline
    }

    @MainActor
    public func loadImage() async {
        guard let url = imageURL else { return }
        imageState.isLoading = true
        do {
            let response = try await pipeline.image(for: URLRequest(url: url))
            imageState.image = response.image
        } catch {
            logger.error("Image load failed: \(error.localizedDescription)")
        }
        imageState.isLoading = false
    }
}

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif
