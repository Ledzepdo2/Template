import SwiftUI

public struct MVVMLoaderView: View {
    @State private var viewModel: MVVMLoaderViewModel

    public init(viewModel: MVVMLoaderViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        VStack(spacing: 16) {
            if viewModel.imageState.isLoading {
                ProgressView()
            } else if let image = viewModel.imageState.image {
                #if os(iOS) || os(tvOS)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240)
                #else
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240)
                #endif
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)
            }

            Button("Reload image") {
                Task { await viewModel.loadImage() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .task {
            await viewModel.loadImage()
        }
    }
}

#Preview {
    MVVMLoaderView(viewModel: .init(imageURL: URL(string: "https://placekitten.com/200/200")))
}
