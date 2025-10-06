import XCTest
@testable import MVVMFeature

final class MVVMLoaderViewModelTests: XCTestCase {
    func testLoadImageWithoutURL() async {
        let viewModel = MVVMLoaderViewModel(imageURL: nil)
        await viewModel.loadImage()
        await MainActor.run {
            XCTAssertFalse(viewModel.imageState.isLoading)
            XCTAssertNil(viewModel.imageState.image)
        }
    }
}
