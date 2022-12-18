// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class GenericAPIMapper<RemoteAPIModel: Decodable, DomainModel> {
    private init() {}
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse, domainMapper: (RemoteAPIModel) -> DomainModel) throws -> DomainModel {
        guard response.statusCode == OK_200,
              let remoteModel = try? JSONDecoder().decode(RemoteAPIModel.self, from: data) else {
            throw Error.invalidData
        }
        return domainMapper(remoteModel)
    }
}
