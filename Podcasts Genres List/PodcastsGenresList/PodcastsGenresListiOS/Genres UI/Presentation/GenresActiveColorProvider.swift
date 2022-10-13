// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class GenresActiveColorProvider<Color> {
    
    private enum Error: Swift.Error {
        case invalidColorsList(String)
        case emptyColorsList
    }
    
    private let colorConverted: (String) -> Color
    public private(set) var colors: [String] = []
    
    public init(colorConverted: @escaping (String) -> Color) {
        self.colorConverted = colorConverted
    }
    
    public func getColor(by index: Int) throws -> Color {
        guard !colors.isEmpty else {
            throw Error.emptyColorsList
        }
        
        guard index >= colors.count else {
            return colorConverted(colors[index])
        }
        
        let inxedWithoutOverflow = index % colors.count
        
        return colorConverted(colors[inxedWithoutOverflow])
    }
    
    public func setColors(_ colors: [String]) throws {
        guard !colors.isEmpty else {
            throw Error.emptyColorsList
        }
        
        try colors.forEach { try validate($0) }
        self.colors = colors
    }
    
    private func validate(_ color: String) throws -> Void {
        let preparedColorString = color.replacingOccurrences(of: "#", with: "")
        let isColorsStringValid = preparedColorString.filter(\.isHexDigit).count == preparedColorString.count
        if isColorsStringValid {
            return
        }
        throw Error.invalidColorsList("Invalid hex color string: \(color)")
    }
}
