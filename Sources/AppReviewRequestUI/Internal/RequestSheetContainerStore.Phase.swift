//
//  File.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//
import SwiftUI
import AppReviewRequest

extension RequestSheetContainerStore.Phase {
    init(_ scenePhase: ScenePhase) {
        switch scenePhase {
            case .active:
            self = .active
        case .background:
            self = .background
        case .inactive:
            self = .inactive
        @unknown default:
            fatalError()
        }
    }
}
