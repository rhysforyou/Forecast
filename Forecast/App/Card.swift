//
//  Card.swift
//  Forecast
//
//  Created by Rhys Powell on 14/6/2022.
//

import SwiftUI

struct Card<Title, Content>: View where Title: View, Content: View {
    let title: Title
    let content: Content

    init(@ViewBuilder title: () -> Title, @ViewBuilder content: () -> Content) {
        self.title = title()
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            title.foregroundColor(.secondary)
            content
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        #else
        .background(in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        #endif
        .frame(maxWidth: 600)
    }
}

extension Card where Title == Text {
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = Text(title)
        self.content = content()
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Card(title: "Preview") {
                Rectangle()
                    .aspectRatio(2, contentMode: .fit)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(.quaternary)
        .previewLayout(.sizeThatFits)
    }
}
