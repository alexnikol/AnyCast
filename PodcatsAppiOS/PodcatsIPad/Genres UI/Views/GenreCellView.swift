// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI

struct GenreCellView: View {
    let model: GenreCellViewData
    
    var body: some View {
        HStack(spacing: 16) {
            model.color
                .frame(width: 30.0)
            Text(model.name)
                .font(.system(size: 30, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(uiColor: .label))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct GenreCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            GenreCellView(model: GenreCellViewData(id: .init(), name: "Genre", color: .red))
                .frame(width: .infinity, height: 100)
                .previewLayout(.sizeThatFits)

            let longName = String(repeating: "long long", count: 10)
            GenreCellView(model: GenreCellViewData(id: .init(), name: "Genre 2 " + longName, color: .red))
                .frame(width: .infinity, height: 100)
                .previewLayout(.sizeThatFits)
        }
    }
}
