// Copyright © 2022 Almost Engineer. All rights reserved.

import LoadResourcePresenter

final class NullObjectStateResourceView: ResourceLoadingView, ResourceErrorView {
    func display(_ viewModel: ResourceLoadingViewModel) {}
    func display(_ viewModel: ResourceErrorViewModel) {}
}
