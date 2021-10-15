import Foundation

extension String {
    func components<T>(transform: ([Self]) -> [T]) -> [T] {
        {
            $0.isEmpty ? [] : transform($0)
        } (trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter {
                !$0.isEmpty
            })
    }
}
