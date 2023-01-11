// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> CurrentEpisodeEntry {
        CurrentEpisodeEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CurrentEpisodeEntry) -> ()) {
        let entry = CurrentEpisodeEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CurrentEpisodeEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CurrentEpisodeEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CurrentEpisodeEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct PlayingEpisodeModel {
    let episodeTitle: String
    let podcastTitle: String
    let timeLabel: String
    let thumbnail: URL
}

struct Podcast_WidgetsEntryView : View {
    var entry: Provider.Entry
    var model: PlayingEpisodeModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, Color("AccentColor")]),
                startPoint: .topLeading,
                endPoint: .trailing
            )
            VStack {
                HStack(alignment: .top) {
                    Rectangle()
                        .frame(width: 80, height: 80)
                        .cornerRadius(4)
                    Spacer()
                    VStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 35.0, height: 35.0)
                    }
                    .frame(width: 50.0, height: 50.0)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text(model.timeLabel)
                        .font(Font.system(size: 12, weight: .regular))
                    
                    Text(model.episodeTitle)
                        .font(Font.system(size: 18, weight: .bold))
                    
                    Text(model.podcastTitle)
                        .font(Font.system(size: 17, weight: .medium))
                }
                .lineLimit(1)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .topLeading)
            }.padding(4)
        }
    }
}

struct Podcast_Widgets: Widget {
    let kind: String = "Podcast_Widgets"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            Podcast_WidgetsEntryView(
                entry: entry,
                model: PlayingEpisodeModel(
                    episodeTitle: "Episode Title",
                    podcastTitle: "Podcast Title",
                    timeLabel: "left 40 min",
                    thumbnail: URL(string: "https://any-url.com")!)
            )
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct Podcast_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Podcast_WidgetsEntryView(
            entry: CurrentEpisodeEntry(date: Date(), configuration: ConfigurationIntent()),
            model: PlayingEpisodeModel(
                episodeTitle: "Episode Title",
                podcastTitle: "Podcast Title",
                timeLabel: "left 40 min",
                thumbnail: URL(string: "https://any-url.com")!)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
