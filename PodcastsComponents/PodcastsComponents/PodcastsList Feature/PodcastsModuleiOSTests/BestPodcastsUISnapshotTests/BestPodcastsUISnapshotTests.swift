// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import LoadResourcePresenter
import PodcastsModule
import PodcastsModuleiOS

class BestPodcastsUISnapshotTests: XCTestCase {
    
    func test_emptyBestPodcasts() {
        let (sut, _) = makeSUT()
        
        sut.display(emptyPodcasts())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_BEST_PODCASTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_BEST_PODCASTS_dark")
    }
    
    func test_bestPodcastsWithContent() {
        let (sut, _) = makeSUT()
        
        sut.display(podcastsList())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "BEST_PODCASTS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "BEST_PODCASTS_WITH_CONTENT_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ListViewController, loadingView: ResourceLoadingView) {
        let refreshController = RefreshViewController(delegate: NullObjectRefreshViewControllerDelegate())
        let controller = ListViewController(refreshController: refreshController)
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return (controller, refreshController)
    }
    
    private func emptyPodcasts() -> [PodcastCellController] {
        return []
    }
    
    private func podcastsList() -> [PodcastCellController] {
        let models: [PodcastImageViewModel] = [
            .init(
                title: "Any name",
                publisher: "Any publisher",
                languageStaticLabel: "Language:",
                languageValueLabel: "Any language",
                typeStaticLabel: "Type:",
                typeValueLabel: "Any type",
                image: anyURL()),
            .init(
                title: "Long long long long long long long long long long long long long long long long name",
                publisher: "Long long long long long publisher",
                languageStaticLabel: "Language:",
                languageValueLabel: "Long long long long long language",
                typeStaticLabel: "Type:",
                typeValueLabel: "Long long long long long type",
                image: anyURL()),
            .init(
                title: "Long long long long long long long long long long long long long long long long name",
                publisher: "Long long long long long publisher",
                languageStaticLabel: "Language:",
                languageValueLabel: "Long long long long long language",
                typeStaticLabel: "Type:",
                typeValueLabel: "Long long long long long type",
                image: anyURL()),
        ]
        
        let stubbedImages: [UIImage?] = [UIImage.make(withColor: .blue), nil, UIImage.make(withColor: .yellow)]
        
        return models.enumerated().map { (index, viewModel) in
            let imageStub = ImageStub(image: stubbedImages[index])
            let cellController = PodcastCellController(
                model: viewModel,
                delegete: imageStub
            )
            imageStub.imageDataResourceView = cellController
            return cellController
        }
    }
        
    private class NullObjectRefreshViewControllerDelegate: RefreshViewControllerDelegate {
        func didRequestLoading() {}
    }
    
    private class ImageStub: PodcastCellControllerDelegate {
        private let image: UIImage?
        
        init(image: UIImage?) {
            self.image = image
        }
        
        weak var imageDataResourceView: PodcastCellController?
        
        func didRequestImage() {
            if let image = image {
                imageDataResourceView?.display(image)
            } else {
                imageDataResourceView?.display(ResourceErrorViewModel(message: "ERROR_MESSAGE"))
            }
        }
        
        func didCancelImageLoad() {}
    }
}
