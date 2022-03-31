import Foundation
import Domains

extension String {
    public var domain: String {
        replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .components(separatedBy: "/")
            .first!
            .components(separatedBy: ":")
            .first
            .map(Tld.domain(host:))!
            .minimal
            .lowercased()
    }
    
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
