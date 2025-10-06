import SwiftUI
import Lottie
#if canImport(UIKit)
import UIKit
#endif

public struct CleanListView: View {
    @StateObject private var controller: CleanListController

    public init() {
        _controller = StateObject(wrappedValue: CleanListController())
    }

    public var body: some View {
        NavigationStack {
            List(controller.items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay(alignment: .center) {
                if controller.items.isEmpty {
                    LottieLoopView(animationName: "Loading")
                        .frame(width: 120, height: 120)
                        .task { controller.load() }
                }
            }
            .navigationTitle("Clean Swift")
            .toolbar {
                Button("Refresh") {
                    controller.refresh()
                }
            }
        }
    }
}

@MainActor
final class CleanListController: ObservableObject, CleanListDisplayLogic {
    @Published var items: [CleanListModels.ViewModel] = []

    private lazy var presenter = CleanListPresenter(view: self)
    private lazy var interactor = CleanListInteractor(presenter: presenter)

    func load() {
        interactor.load()
    }

    func refresh() {
        interactor.refresh()
    }

    func display(viewModel: [CleanListModels.ViewModel]) {
        items = viewModel
    }
}

#Preview {
    CleanListView()
}

struct LottieLoopView: View {
    let animationName: String

    init(animationName: String) {
        self.animationName = animationName
    }

    var body: some View {
        #if canImport(UIKit)
        Representable(animationName: animationName)
            .onAppear {}
        #else
        ProgressView()
        #endif
    }

#if canImport(UIKit)
    private struct Representable: UIViewRepresentable {
        let animationName: String

        func makeUIView(context: Context) -> LottieAnimationView {
            let view = LottieAnimationView(name: animationName, bundle: .main)
            view.loopMode = .loop
            view.play()
            return view
        }

        func updateUIView(_ uiView: LottieAnimationView, context: Context) {
            if !uiView.isAnimationPlaying {
                uiView.play()
            }
        }
    }
#endif
}
