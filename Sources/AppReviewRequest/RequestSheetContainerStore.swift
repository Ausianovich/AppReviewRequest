//
//  RequestSheetContainerStore.swift
//  AppReviewRequest
//
//  Created by Kanstantsin Ausianovich on 03/09/2026.
//
import ComposableArchitecture
import AppGlobalState
import Foundation

@Reducer
public struct RequestSheetContainerStore {
    
    @Dependency(\.openURL) private var openURL
    
    public enum Phase {
        case active
        case background
        case inactive
    }
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var requestStore: RequestSheetStore.State?
        @Shared(.launchCount) var launchCount: Int
        @Shared(.rateRequestAproved) var rateAproved: Bool
        
        let applicationID: String
        let firstPresentation: Int
        let eachNextPresentation: Int
        var lastPresentedSession: Int?
        
        public init(applicationID: String, firstPresentation: Int, eachNextPresentation: Int) {
            self.applicationID = applicationID
            self.firstPresentation = firstPresentation
            self.eachNextPresentation = eachNextPresentation
        }
    }
    
    public enum Action {
        case updateState(Phase)
        case presentRequestView
        case requestStore(PresentationAction<RequestSheetStore.Action>)
        case rateAproved
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .updateState(let phase):
                if phase == .active {
                    return .run { send in
                        await send(.presentRequestView)
                    }
                }
                return .none
            case .presentRequestView:
                if let lastPresentedSession = state.lastPresentedSession, state.launchCount == lastPresentedSession {
                    return .none
                }
                
                guard !state.rateAproved else {
                    return .none
                }
                
                if state.launchCount < state.firstPresentation {
                    return .none
                }
                
                let sessionsSinceFirstPresentation = state.launchCount - state.firstPresentation
                guard sessionsSinceFirstPresentation % state.eachNextPresentation == 0 else {
                    return .none
                }
                
                state.requestStore = RequestSheetStore.State()
                state.lastPresentedSession = state.launchCount
                
                return .none
            case .requestStore(.presented(.openAppLink)):
                
                state.requestStore = nil
                
                let url = URL(string: "https://apps.apple.com/app/id\(state.applicationID)?action=write-review")!
                
                return .run { [openURL] send in
                    await openURL(url)
                    await send(.rateAproved)
                }
            case .rateAproved:
                state.$rateAproved.withLock { value in
                    value = true
                }
                return .none
            case .requestStore:
                return .none
            }
        }
        .ifLet(\.$requestStore, action: \.requestStore) {
            RequestSheetStore()
        }
    }
}


