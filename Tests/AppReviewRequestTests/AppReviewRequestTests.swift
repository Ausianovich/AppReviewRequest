import ComposableArchitecture
import CustomDump
import Foundation
import Synchronization
import Testing
@testable import AppReviewRequest

@MainActor
@Suite(.serialized)
struct RequestSheetContainerStoreTests {
    @Test func coldStartPresentsRequestViewWhenCurrentLaunchCountMatchesCadence() async {
        let store = makeStore(launchCount: 4, firstPresentation: 2, eachNextPresentation: 2)
        
        await store.send(.launchCountChanged) {
            $0.requestStore = RequestSheetStore.State()
            $0.lastPresentedSession = 4
        }
    }
    
    @Test func launchCountChangedDoesNotPresentRequestViewOutsideCadence() async {
        let store = makeStore(launchCount: 5, firstPresentation: 2, eachNextPresentation: 2)
        
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, nil)
    }
    
    @Test func launchCountChangedWaitsForFirstPresentationLaunchCount() async {
        let store = makeStore(launchCount: 2, firstPresentation: 3, eachNextPresentation: 1)
        
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, nil)
    }
    
    @Test func launchCountChangedDoesNotPresentOnZeroLaunchCountBeforeFirstPresentation() async {
        let store = makeStore(launchCount: 0, firstPresentation: 3, eachNextPresentation: 10)
        
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, nil)
    }
    
    @Test func launchCountChangedFollowsEachNextPresentationCadence() async {
        let store = makeStore(launchCount: 5, firstPresentation: 3, eachNextPresentation: 3)
        
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, nil)
    }
    
    @Test func launchCountChangedPresentsAfterFirstPresentationPlusNextCadence() async {
        let store = makeStore(launchCount: 13, firstPresentation: 3, eachNextPresentation: 10)
        
        await store.send(.launchCountChanged) {
            $0.requestStore = RequestSheetStore.State()
            $0.lastPresentedSession = 13
        }
    }
    
    @Test func foregroundingWithoutNewLaunchDoesNotPresentRequestViewAgain() async {
        let store = makeStore(
            launchCount: 6,
            firstPresentation: 3,
            eachNextPresentation: 3
        )
        
        await store.send(.launchCountChanged) {
            $0.requestStore = RequestSheetStore.State()
            $0.lastPresentedSession = 6
        }
        await store.send(.requestStore(.dismiss)) {
            $0.requestStore = nil
        }

        // A repeated callback with the same launch count models a view
        // reappearing after the application returns to the foreground.
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, 6)
    }
    
    @Test func launchCountChangedDoesNotPresentAfterRateApproval() async {
        let store = makeStore(
            launchCount: 6,
            rateAproved: true,
            firstPresentation: 3,
            eachNextPresentation: 3
        )
        
        await store.send(.launchCountChanged)

        expectNoDifference(store.state.requestStore, nil)
        expectNoDifference(store.state.lastPresentedSession, nil)
        expectNoDifference(store.state.rateAproved, true)
    }
    
    @Test func openingAppLinkDismissesRequestViewOpensReviewURLAndApprovesRateRequest() async {
        let expectedURL = URL(string: "https://apps.apple.com/app/id123456789?action=write-review")!
        let openedURL = Mutex<URL?>(nil)
        let store = makeStore(
            launchCount: 6,
            firstPresentation: 3,
            eachNextPresentation: 3,
            isRequestStorePresented: true
        )
        store.dependencies.openURL = OpenURLEffect { url in
            openedURL.withLock { $0 = url }
            return true
        }
        
        await store.send(.requestStore(.presented(.openAppLink))) {
            $0.requestStore = nil
        }
        await store.receive(\.rateAproved) {
            $0.$rateAproved.withLock { $0 = true }
        }
        
        expectNoDifference(openedURL.withLock { $0 }, Optional(expectedURL))
    }
    
    @Test func requestStoreDismissClearsPresentedRequestView() async {
        let store = makeStore(
            launchCount: 6,
            firstPresentation: 3,
            eachNextPresentation: 3,
            isRequestStorePresented: true
        )
        
        await store.send(.requestStore(.dismiss)) {
            $0.requestStore = nil
        }
    }
}

@MainActor
private func makeStore(
    launchCount: Int,
    rateAproved: Bool = false,
    firstPresentation: Int,
    eachNextPresentation: Int,
    lastPresentedSession: Int? = nil,
    applicationID: String = "123456789",
    isRequestStorePresented: Bool = false
) -> TestStoreOf<RequestSheetContainerStore> {
    var state = RequestSheetContainerStore.State(
        applicationID: applicationID,
        firstPresentation: firstPresentation,
        eachNextPresentation: eachNextPresentation
    )
    state.$launchCount.withLock { $0 = launchCount }
    state.$rateAproved.withLock { $0 = rateAproved }
    state.lastPresentedSession = lastPresentedSession
    if isRequestStorePresented {
        state.requestStore = RequestSheetStore.State()
    }
    
    return TestStore(initialState: state) {
        RequestSheetContainerStore()
    }
}
