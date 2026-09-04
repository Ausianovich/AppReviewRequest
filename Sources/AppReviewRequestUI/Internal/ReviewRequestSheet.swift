//
//  ReviewRequestSheet.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import SwiftUI
import ComposableArchitecture
import AppReviewRequest

struct ReviewRequestSheet: View {
    private let configuration: ReviewRequestSheetConfiguration
    private let store: StoreOf<RequestSheetStore>
    @State private var contentHeight: CGFloat = 1

    init(
        store: StoreOf<RequestSheetStore>,
        configuration: ReviewRequestSheetConfiguration
    ) {
        self.store = store
        self.configuration = configuration
    }

    var body: some View {
        VStack(spacing: 20) {
            configuration.icon
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(configuration.tint)
                .accessibilityHidden(true)

            Text(configuration.title)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)

            Text(configuration.message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button {
                store.send(.openAppLink)
            } label: {
                Text(configuration.rateButtonTitle)
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.glassProminent)

            Button {
                store.send(.maybeLaterButtonTapped)
            } label: {
                Text(configuration.maybeLaterButtonTitle)
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.glass)
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(24)
        .tint(configuration.tint)
        .onGeometryChange(for: CGFloat.self, of: \.size.height) {
            contentHeight = $0
        }
        .presentationDetents([.height(contentHeight)])
        .presentationDragIndicator(.visible)
    }
}
