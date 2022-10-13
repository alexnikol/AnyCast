// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public class GenresActiveColorProvider {
    
    private enum Error: Swift.Error {
        case invalidColorsList(String)
        case emptyColorsList
    }
    
    public private(set) var colors: [String] = []
    
    public init() {}
    
    public func getColor(by index: Int) throws -> UIColor {
        guard !colors.isEmpty else {
            throw Error.emptyColorsList
        }
        
        guard index >= colors.count else {
            return UIColor(hexString: colors[index])
        }
        
        let inxedWithoutOverflow = index % colors.count
        
        return UIColor(hexString: colors[inxedWithoutOverflow])
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
