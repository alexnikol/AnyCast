// Copyright © 2023 Almost Engineer. All rights reserved.

import HTTPClient
import URLSessionHTTPClient
import PodcastsGenresList
import SearchContentModule
import SwiftUI
import Combine

@main
struct PodcatsIPadApp: App {
    
    var body: some Scene {
        
        return WindowGroup {
            TabView {
                NavigationView {
                    GenresUIComposer.genresComposedWith(loader: makeLocalGenresLoaderWithRemoteFallback, selection: { _ in })
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Explore", systemImage: "rectangle.grid.2x2.fill")
                }
                
                NavigationView {
                    let (view, sourceDelegate) = GeneralSearchUIComposer.generalSearchComposedWith(
                        searchLoader: makeRemoteGeneralSearchLoader(term:),
                        onEpisodeSelect: { _ in },
                        onPodcastSelect: { _ in }
                    )
                    
                    let typeheadView = TypeaheadSearchUIComposer
                        .typeheadSearchComposedWith(
                            searchLoader: makeRemoteTypeaheadSearchLoader(term:),
                            onTermSelect: sourceDelegate.didUpdateSearchTerm
                        )
                    
                    typeheadView
                    
                    view
                }
                .navigationViewStyle(.columns)
                .tabItem {
                    Label("Search", systemImage: "waveform.and.magnifyingglass")
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

func makeRemoteTypeaheadSearchLoader(term: String) -> AnyPublisher<TypeaheadSearchContentResult, Error> {
    let requestURL = SearchEndpoint.getTypeaheadSearch(term: term).url(baseURL: baseURL)
    return httpClient
        .loadPublisher(from: requestURL)
        .tryMap(TypeaheadSearchContentMapper.map)
        .eraseToAnyPublisher()
}

func makeRemoteGeneralSearchLoader(term: String) -> AnyPublisher<GeneralSearchContentResult, Error> {
    let requestURL = SearchEndpoint.getGeneralSearch(term: term).url(baseURL: baseURL)
    return httpClient
        .loadPublisher(from: requestURL)
        .tryMap(GeneralSearchContentMapper.map)
        .eraseToAnyPublisher()
}
