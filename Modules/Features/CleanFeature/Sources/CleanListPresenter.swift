import Foundation

public final class CleanListPresenter: CleanListPresentationLogic {
    private weak var view: CleanListDisplayLogic?

    public init(view: CleanListDisplayLogic) {
        self.view = view
    }

    public func present(response: CleanListModels.Response) {
        let viewModels = response.items.map { item in
            CleanListModels.ViewModel(id: item.id, title: item.title, subtitle: item.subtitle)
        }
        view?.display(viewModel: viewModels)
    }
}
