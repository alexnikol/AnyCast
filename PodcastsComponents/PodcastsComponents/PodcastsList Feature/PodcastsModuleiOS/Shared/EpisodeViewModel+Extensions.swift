// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

extension EpisodeViewModel {
    var descriptionWithHTMLMarkup: NSAttributedString {
        if let htmlString = try? NSMutableAttributedString(
            data: Data(description.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) {
            return htmlString
        } else {
            return NSAttributedString(string: description)
        }
    }
}
