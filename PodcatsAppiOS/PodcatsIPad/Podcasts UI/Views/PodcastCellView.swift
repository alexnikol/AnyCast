// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import PodcastsModule

struct PodcastCellView: View {
    
    let model: PodcastImageViewModel
    
    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemBackground)
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .frame(width: 160, height: 160)
                    .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(model.title)
                        .font(.title)
                        .lineLimit(2)
                    
                    Text(model.publisher)
                        .font(.title2)
                        .lineLimit(1)
                        .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                    
                    HStack(alignment: .top, spacing: 4) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(model.languageStaticLabel)
                            Text(model.typeStaticLabel)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(model.languageValueLabel)
                            Text(model.typeValueLabel)
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                    .font(.body)
                    .lineLimit(1)
                }
            }
        }
    }
}

struct PodcastCellView_Previews: PreviewProvider {
    static var previews: some View {
        let previewData = getPreviewData()
                
        List {
            ForEach(previewData, id: \.self) { model in
                PodcastCellView(model: model)
            }
        }
    }
    
    private static func getPreviewData() -> [PodcastImageViewModel] {
        let podcast1 = Podcast(
            id: UUID().uuidString,
            title: "Podcast title",
            publisher: "Publisher title",
            language: "English",
            type: .episodic,
            image: URL(string: "https://any-image-url.com")!
        )
        let podcast2 = Podcast(
            id: UUID().uuidString,
            title: "Podcast title".repeatTimes(10),
            publisher: "Publisher title".repeatTimes(10),
            language: "English".repeatTimes(30),
            type: .episodic,
            image: URL(string: "https://any-image-url.com")!
        )
        let model1 = BestPodcastsPresenter.map(podcast1)
        let model2 = BestPodcastsPresenter.map(podcast2)
        
        return [model1, model2]
    }
}
