// Copyright © 2023 Almost Engineer. All rights reserved.

import HTTPClient
import URLSessionHTTPClient
import PodcastsGenresList
import SwiftUI
import Combine

@main
struct PodcatsIPadApp: App {

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    GenresUIComposer.genresComposedWith(loader: makeLocalGenresLoaderWithRemoteFallback, selection: { _ in })
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Label("Explore", systemImage: "rectangle.grid.2x2.fill")
                }
            }
        }
    }
}

private var baseURL: URL = {
    URL(string: "https://listen-api-test.listennotes.com")!
}()

private var httpClient: HTTPClient = {
    return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
}()

func makeLocalGenresLoaderWithRemoteFallback() -> AnyPublisher<[Genre], Error> {
    struct EmptyCache: Error {}
    let requestURL = GenresEndpoint.getGenres.url(baseURL: baseURL)
    return httpClient
        .loadPublisher(from: requestURL)
        .tryMap(GenresItemsMapper.map)
        .eraseToAnyPublisher()
}
