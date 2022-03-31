import Foundation

extension Access {
    struct Local: AccessType {
        let key = Access.local
        let value: String
        
        let bookmark: Data
        
        init(value: String, bookmark: Data) {
            self.value = value
            self.bookmark = bookmark
        }
        
        func open(completion: (_ file: URL, _ directory: URL) -> Void) {
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
        
        var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
            .wrapping(size: UInt16.self, data: bookmark)
        }
    }
}
