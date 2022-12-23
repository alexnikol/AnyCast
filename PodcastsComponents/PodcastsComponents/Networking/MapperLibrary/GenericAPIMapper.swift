// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum GenericAPIMapper<RemoteAPIModel: Decodable, DomainModel> {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse, domainMapper: (RemoteAPIModel) -> DomainModel) throws -> DomainModel {
        guard response.statusCode == OK_200 else {
            throw Error.invalidData
        }
        
        do {
            let remoteModel = try JSONDecoder().decode(RemoteAPIModel.self, from: data)
            return domainMapper(remoteModel)
        } catch {
            NSLog("MAPPER__DECODING__ISSUE \(RemoteAPIModel.self), \(error), \(error.localizedDescription)")
            throw Error.invalidData
        }
    }
}
