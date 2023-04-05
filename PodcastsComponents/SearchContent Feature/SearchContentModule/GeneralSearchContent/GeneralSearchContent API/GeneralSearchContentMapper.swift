// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary

public enum GeneralSearchContentMapper {
    typealias Mapper = GenericAPIMapper<RemoteGeneralSearchContentResult, GeneralSearchContentResult>
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> GeneralSearchContentResult {
        return try Mapper.map(data, from: response, domainMapper: RemoteGeneralSearchContentResult.toDomainModel)
    }
}

private extension RemoteGeneralSearchContentResult {
    static func toDomainModel(remoteModel: RemoteGeneralSearchContentResult) -> GeneralSearchContentResult {
        GeneralSearchContentResult(result: remoteModel.results.map { $0.toDomainModel() })
    }
}

private extension RemoteGeneralSearchContentResultItem {
    func toDomainModel() -> GeneralSearchContentResultItem {
        switch self {
        case .podcast(let remoteSearchResultPodcast):
            return .podcast(remoteSearchResultPodcast.toDomainModel())
        case .episode(let remoteSearchResultEpisode):
            return .episode(remoteSearchResultEpisode.toDomainModel())
        case .curatedList(let remoteSearchResultCuratedList):
            return .curatedList(remoteSearchResultCuratedList.toDomainModel())
        }
    }
}
