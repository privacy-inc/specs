import Foundation

public protocol AccessURL: AccessType {

}

extension AccessURL {
    public var url: URL? {
        .init(string: value)
    }
    
    public var content: Data {
        .init()
        .adding(UInt16.self, string: value)
    }
}
