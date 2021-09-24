import Foundation
import Domains

extension String {    
    func browse<Result>(engine: Engine, result: (Self) -> Result) -> Result? {
        trimmed {
            $0.url
                ?? $0.file
                ?? $0.partial
                ?? engine.query($0)
        }
        .map(result)
    }
    
    private func trimmed(transform: (Self) -> Self?) -> Self? {
        {
            $0.isEmpty ? nil : transform($0)
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private var url: Self? {
        (.init(string: self)
            ?? addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.union(.urlFragmentAllowed))
            .flatMap(URL.init(string:)))
                .flatMap {
                    $0.scheme != nil && ($0.host != nil || $0.query != nil)
                        ? $0.absoluteString
                        : nil
                }
    }
    
    private var file: Self? {
        {
            $0
                .flatMap {
                    $0.isFileURL ? self : nil
                }
        } (URL(string: self))
    }
    
    private var partial: Self? {
        {
            $0.count > 1
                && $0
                    .last
                    .flatMap {
                        Tld.suffix[$0]
                    } != nil
                && !$0.first!.isEmpty
                && !contains(" ")
                ? URL.Scheme.https.rawValue + "://" + self
                : nil
        } (components(separatedBy: "/")
            .first!
            .components(separatedBy: "."))
    }
}
