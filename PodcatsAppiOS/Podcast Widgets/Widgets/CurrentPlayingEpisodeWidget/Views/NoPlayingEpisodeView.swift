// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI
import AudioPlayerModule

struct NoPlayingEpisodeView: View {
    
    var body: some View {
        ZStack {
            MainThemeBackgoundGradient()
            
            VStack {
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 60.0, height: 60.0)
                }
                .frame(width: 50.0, height: 50.0)
                Spacer().frame(height: 20)
                Text(CurrentEpisodeWidgetPresenter.noPlayingEpisodeTitle)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(uiColor: .black.withAlphaComponent(0.6)))
            }.padding()
        }
    }
}

struct Previews_NoPlayingItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        NoPlayingEpisodeView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
