// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI
import AudioPlayerModule

struct PlayingEpisodeView: View {
    let model: CurrentEpisodeWidgetViewModel
    
    var body: some View {
        ZStack {
            MainThemeBackgoundGradient()
            
            VStack {
                HStack(alignment: .top) {
                    if let data = model.thumbnailData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(4)
                    } else {
                        Rectangle()
                            .foregroundColor(Color(UIColor.label))
                            .opacity(0.3)
                            .frame(width: 80, height: 80)
                            .cornerRadius(4)
                    }
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
                        .font(Font.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(uiColor: .black.withAlphaComponent(0.6)))

                    Text(model.episodeTitle)
                        .font(Font.system(size: 15, weight: .semibold))

                    Text(model.podcastTitle)
                        .font(Font.system(size: 14, weight: .medium))
                }
                .lineLimit(1)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .topLeading)
            }.padding(8)
        }
    }
}

struct Previews_PlayingItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            let model = CurrentEpisodeWidgetViewModel(
                episodeTitle: "Title",
                podcastTitle: "Title",
                timeLabel: "2 min left",
                thumbnailData: nil
            )
            PlayingEpisodeView(model: model)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        
            let model2 = CurrentEpisodeWidgetViewModel(
                episodeTitle: "Title long long long long long long",
                podcastTitle: "Title long long long long long long",
                timeLabel: "2 min left long long long long long long",
                thumbnailData: nil
            )
            PlayingEpisodeView(model: model2)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
