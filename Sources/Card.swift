import Foundation
import Archivable

public struct Card: Storable, Identifiable, Equatable {
    public let id: ID
    public let state: Bool

    public var data: Data {
        .init()
        .adding(id.rawValue)
        .adding(state)
    }
    
    public init(data: inout Data) {
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
