import ComposableArchitecture
import CustomDump
import Synchronization
import Testing
@testable import AppReviewRequest

@MainActor
@Suite(.serialized)
struct RequestSheetStoreTests {
    @Test func openAppLinkDoesNotMutateState() async {
        let store = TestStore(initialState: RequestSheetStore.State()) {
            RequestSheetStore()
        }
        
        await store.send(.openAppLink)
        
        expectNoDifference(store.state, RequestSheetStore.State())
    }
    
    @Test func maybeLaterButtonTappedDismissesSheet() async {
        let dismissed = Mutex(false)
        let store = TestStore(initialState: RequestSheetStore.State()) {
            RequestSheetStore()
        }
        store.dependencies.dismiss = DismissEffect {
            dismissed.withLock { $0 = true }
        }
        
        await store.send(.maybeLaterButtonTapped)
        await store.finish()
        
        expectNoDifference(dismissed.withLock { $0 }, true)
    }
}
