//
//  RequestViewModifier.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import SwiftUI

struct RequestViewModifier: ViewModifier {
    private let configuration: ReviewRequestSheetConfiguration
    
    init(configuration: ReviewRequestSheetConfiguration) {
        self.configuration = configuration
    }
    
    func body(content: Content) -> some View {
        RequestSheetContainer(configuration: configuration, content: { content} )
    }
}
