// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI

struct MainThemeBackgoundGradient: View {
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [.white, Color("AccentColor"), Color("AccentColor")]
            ),
            startPoint: .topLeading,
            endPoint: .trailing
        )
    }
}

struct Previews_MainThemeBackgoundGradient_Previews: PreviewProvider {
    
    static var previews: some View {
        MainThemeBackgoundGradient()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
