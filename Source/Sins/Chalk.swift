//
//  Chalk.swift
//  Sins
//
//  Created by user on 2/17/26.
//

import SwiftUI

struct Chalk: ViewModifier {
    let fontType: Font.TextStyle

    func body(content: Content) -> some View {
        // Map to a UIKit text style so we can use UIFontMetrics for Dynamic Type scaling
        let uiStyle = uiTextStyle(for: fontType)
        // Base point size for that text style
        let baseSize = UIFont.preferredFont(forTextStyle: uiStyle).pointSize
        // Scale it for the current content size category (Dynamic Type)
        let scaledSize = UIFontMetrics(forTextStyle: uiStyle).scaledValue(for: baseSize)

        return content
            .font(.custom("Chalkduster", size: scaledSize))
    }

    private func uiTextStyle(for style: Font.TextStyle) -> UIFont.TextStyle {
        switch style {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .callout: return .callout
        case .caption: return .caption1
        case .caption2: return .caption2
        case .footnote: return .footnote
        default: return .body
        }
    }
}

extension View {
    func chalk(_ fontType: Font.TextStyle) -> some View {
        modifier(Chalk(fontType: fontType))
    }
}
