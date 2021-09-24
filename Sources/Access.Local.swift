import Foundation

extension Access {
    public struct Local: AccessType {
        public let key = Access.local
        public let value: String
        public let path: String
        let file: String
        let bookmark: Data
        
        init(value: String, bookmark: Data) {
            self.value = value
            self.bookmark = bookmark
            path = value
                .components(separatedBy: "://")
                .last ?? ""
            file = path
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
                .adding(value)
                .wrapping(bookmark)
        }
    }
}
