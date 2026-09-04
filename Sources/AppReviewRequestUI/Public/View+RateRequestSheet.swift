//
//  RateRequest.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import SwiftUI

public extension View {
    public func rateRequestSheet(configuration: ReviewRequestSheetConfiguration) -> some View {
        modifier(RequestViewModifier(configuration: configuration))
    }
}
