//
//  RequestSheetContainer.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import SwiftUI
import ComposableArchitecture
import AppReviewRequest

public struct RequestSheetContainer<Content: View>: View {
    @Bindable var store: StoreOf<RequestSheetContainerStore>
    
    let content: Content
    let configuration: ReviewRequestSheetConfiguration
    init(configuration: ReviewRequestSheetConfiguration, @ViewBuilder content: () -> Content) {
        self.configuration = configuration
        self.store = Store(initialState: RequestSheetContainerStore.State(applicationID: configuration.applicationID, firstPresentation: configuration.firstSessionPresentation, eachNextPresentation: configuration.eachNextSessionPresentation), reducer: { RequestSheetContainerStore() })
        self.content = content()
    }

    init(
        store: StoreOf<RequestSheetContainerStore>,
        configuration: ReviewRequestSheetConfiguration,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.store = store
        self.content = content()
    }
    
    public var body: some View {
        content
            .sheet(item: $store.scope(\.requestStore, action: \.requestStore)) { store in
                ReviewRequestSheet(store: store, configuration: configuration)
            }
            .onChange(of: store.launchCount) {
                store.send(.launchCountChanged)
            }
    }
}
