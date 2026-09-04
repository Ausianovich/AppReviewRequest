//
//  RequestSheetStore.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//

import ComposableArchitecture

@Reducer
public struct RequestSheetStore {
    
    @Dependency(\.dismiss) private var dismiss
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init () {}
    }
    
    public enum Action {
        case openAppLink
        case maybeLaterButtonTapped
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .openAppLink:
                return .none
            case .maybeLaterButtonTapped:
                return .run { [dismiss] send in
                    await dismiss()
                }
            }
        }
    }
}
