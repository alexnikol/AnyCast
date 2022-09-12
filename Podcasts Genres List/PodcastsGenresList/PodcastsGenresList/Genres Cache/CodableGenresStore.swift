// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class CodableGenresStore: GenresStore {
    
    private struct Cache: Codable {
        let genres: [CodableGenre]
        let timestamp: Date
        
        var localGenres: [LocalGenre] {
            genres.map { $0.local }
        }
    }
    
    private struct CodableGenre: Codable {
        let id: Int
        let name: String
        
        init(_ genre: LocalGenre) {
            id = genre.id
            name = genre.name
        }
        
        var local: LocalGenre {
            return .init(id: id, name: name)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableGenresStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL

    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(genres: cache.localGenres, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let codableGenres = genres.map(CodableGenre.init)
                let cache = Cache(genres: codableGenres, timestamp: timestamp)
                let encoded = try! encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCacheGenres(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                completion(nil)
                return
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
