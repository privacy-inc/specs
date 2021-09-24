import Foundation

extension Access {
    public struct Local {
        public let path: String
        let value: String
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
        
        public func open(completion: (URL, URL) -> Void) {
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
    }
}
