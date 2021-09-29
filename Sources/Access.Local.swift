import Foundation

extension Access {
    public struct Local: AccessType {
        public let key = Access.local
        public let value: String
        public let file: String
        let bookmark: Data
        
        init(value: String, bookmark: Data) {
            self.value = value
            self.bookmark = bookmark
            file = value
                .components(separatedBy: "://")
                .last?
                .components(separatedBy: "/")
                .last ?? ""
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
            .adding(UInt16.self, string: value)
            .wrapping(UInt16.self, data: bookmark)
        }
    }
}
