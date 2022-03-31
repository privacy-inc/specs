import Foundation
import Archivable

#warning("sunset")

struct Card: Storable, Identifiable, Equatable {
    let id: ID
    let state: Bool

    var data: Data {
        .init()
        .adding(id.rawValue)
        .adding(state)
    }
    
    init(data: inout Data) {
        id = .init(rawValue: data.number())!
        state = data.bool()
    }
    
    init(id: ID) {
        self.init(id: id, state: true)
    }
    
    private init(id: ID, state: Bool) {
        self.id = id
        self.state = state
    }
    
    func with(state: Bool) -> Self {
        .init(id: id, state: state)
    }
}
