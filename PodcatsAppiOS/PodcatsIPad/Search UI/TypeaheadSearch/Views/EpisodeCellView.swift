// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import SearchContentModule

struct EpisodeCellView: View {
    
    let model: SearchResultEpisodeViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(uiColor: .secondarySystemBackground)
            VStack(alignment: .leading, spacing: 4) {
                Text(model.displayPublishDate)
                    .lineLimit(1)
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                Text(model.title)
                    .lineLimit(2)
                    .foregroundColor(Color(uiColor: .label))
                Text(model.description)
                    .lineLimit(2)
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                Text(model.displayAudioLengthInSeconds)
                    .lineLimit(1)
                    .foregroundColor(Color.accentColor)
            }.padding(8.0)
        }
    }
}

struct EpisodeCellView_Previews: PreviewProvider {
    static var previews: some View {
        let episode = SearchResultEpisode(
            id: UUID().uuidString,
            title: "Episode title",
            description: "Episode long description",
            thumbnail: URL(string: "https://any-url.com")!,
            audio: URL(string: "https://any-url.com")!,
            audioLengthInSeconds: 123123,
            containsExplicitContent: true,
            publishDateInMiliseconds: 123123123123,
            podcast: SearchResultPodcast(
                id: UUID().uuidString,
                titleOriginal: "Podcast title",
                publisherOriginal: "Publisher name",
                image: URL(string: "https://any-url.com")!,
                thumbnail: URL(string: "https://any-url.com")!
            )
        )
        let presenter = GeneralSearchContentPresenter()
        let viewData = presenter.map(episode)

        EpisodeCellView(model: viewData)
            .previewLayout(.sizeThatFits)
    }
}
