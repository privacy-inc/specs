import Foundation

extension String {
    func components<T>(transform: ([Self]) throws -> [T]) rethrows -> [T] {
        try {
            guard $0.isEmpty else {
                return try transform($0)
            }
            throw Err.ID.invalidURL
        } (trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter {
                !$0.isEmpty
            })
    }
}
