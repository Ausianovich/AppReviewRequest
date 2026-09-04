//
//  ReviewRequestSheetConfiguration.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import SwiftUI

public struct ReviewRequestSheetConfiguration {
    public let icon: Image
    public let maybeLaterButtonTitle: LocalizedStringResource
    public let message: LocalizedStringResource
    public let rateButtonTitle: LocalizedStringResource
    public let tint: Color
    public let title: LocalizedStringResource
    public let applicationID: String
    public let firstSessionPresentation: Int
    public let eachNextSessionPresentation: Int

    public init(
        icon: Image,
        title: LocalizedStringResource,
        message: LocalizedStringResource,
        rateButtonTitle: LocalizedStringResource,
        maybeLaterButtonTitle: LocalizedStringResource,
        tint: Color,
        applicationID: String,
        firstSessionPresentation: Int,
        eachNextSessionPresentation: Int
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.rateButtonTitle = rateButtonTitle
        self.maybeLaterButtonTitle = maybeLaterButtonTitle
        self.tint = tint
        self.applicationID = applicationID
        self.firstSessionPresentation = firstSessionPresentation
        self.eachNextSessionPresentation = eachNextSessionPresentation
    }
}
