//
//  RemoteGenresLoader.swift
//  PodcastsGenresList
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteGenresLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
