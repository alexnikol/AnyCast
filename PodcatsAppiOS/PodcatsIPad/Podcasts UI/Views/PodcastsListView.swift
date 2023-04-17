// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import PodcastsModule

struct PodcastsListView: View {
    @State var models: [PodcastImageViewModel] = []
    @State var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
    @State var columns: [GridItem] = []
    
    var body: some View {
        ScrollView {
            Text("DSDSd")
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                ForEach(models, id: \.self) { model in
                    PodcastCellView(model: model)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .detectOrientation($deviceOrientation)
        .onChange(of: deviceOrientation, perform: updateWithOrientation)
    }
    
    private func updateWithOrientation(_ orientation: UIDeviceOrientation) {
        if orientation.isPortrait {
            columns = [GridItem(.flexible())]
        } else {
            columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        }
    }
}

struct PodcastsListView_Previews: PreviewProvider {
    static var previews: some View {
        let models = getPreviewData() + getPreviewData() + getPreviewData() + getPreviewData()
        PodcastsListView(models: models, deviceOrientation: .portrait)
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
            language: "Ukrainian".repeatTimes(2),
            type: .episodic,
            image: URL(string: "https://any-image-url.com")!
        )
        let model1 = BestPodcastsPresenter.map(podcast1)
        let model2 = BestPodcastsPresenter.map(podcast2)
        return [model1, model2]
    }
}
