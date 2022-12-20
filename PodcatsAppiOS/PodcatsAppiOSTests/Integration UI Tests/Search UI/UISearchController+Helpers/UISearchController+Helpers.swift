// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

extension UISearchController {
    
    func simulateUserInitiatedTyping(with text: String) {
        searchBar.delegate?.searchBar?(searchBar, textDidChange: text)
    }
}
