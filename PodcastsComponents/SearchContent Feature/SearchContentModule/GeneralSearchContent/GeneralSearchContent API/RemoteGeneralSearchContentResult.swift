// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

final class RemoteGeneralSearchContentResult: Decodable {
    let results: [RemoteGeneralSearchContentResultItem]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        results = try root.decode([RemoteGeneralSearchContentResultItem].self, forKey: CodingKeys.results)
    }
}
