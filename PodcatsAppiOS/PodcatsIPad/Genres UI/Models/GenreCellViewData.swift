// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI

struct GenreCellViewData: Identifiable {
    let id: UUID
    let name: String
    let color: Color
    let onSelect: () -> Void
}
