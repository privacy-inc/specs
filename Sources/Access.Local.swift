import Foundation

extension Access {
    public struct Local: AccessType {
        public let key = Access.local
        public let value: String
        
        let bookmark: Data
        
        init(value: String, bookmark: Data) {
            self.value = value
            self.bookmark = bookmark
        }
        
        public func open(completion: (_ file: URL, _ directory: URL) -> Void) {
            bookmark
                .url
                .flatMap { directory in
                    URL(string: value)
                        .map {
                            ($0, directory)
                        }
                }
                .map(completion)
        }
        
        public var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
            .wrapping(size: UInt16.self, data: bookmark)
        }
    }
}
