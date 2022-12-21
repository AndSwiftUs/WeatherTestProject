//
//  View+Extention.swift
//  WeatherTestProject
//
//  Created by Andrew Us on 19.12.2022.
//

import SwiftUI

extension View {
    func onBackSwipe(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.startLocation.x < 50 && value.translation.width > 80 {
                        action()
                    }
                })
        )
    }
}

struct ExDivider: View {
    let color: Color = .white
    let width: CGFloat = 0.5
    let opacity: CGFloat = 0.3
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .opacity(opacity)
    }
}
