// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

final class GeneralSearchPresentationAdapter: GeneralSearchSourceDelegate {
    
    func didUpdateSearchTerm(_ term: String) {
        print("didUpdateSearchTerm \(term)")
    }
}
