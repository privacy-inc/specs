import Foundation
import Archivable

public enum Access: UInt8 {
    case
    remote,
    local,
    deeplink,
    embed
    
    static func with(data: inout Data) -> AccessType {
        switch Self(rawValue: data.removeFirst())! {
        case .remote:
            return Remote(value: data.string())
        case .local:
            return Local(value: data.string(), bookmark: data.unwrap())
        case .deeplink:
            return Deeplink(value: data.string())
        case .embed:
            return Embed(value: data.string())
        }
    }
    
    static func with(url: URL) -> AccessType {
        url.isFileURL
            ? Local(value: url.absoluteString, bookmark: url.deletingLastPathComponent().bookmark)
            : url
                .scheme
                .flatMap(URL.Embed.init(rawValue:))
                .map { _ in
                    Embed(value: url.absoluteString)
                }
                ?? { scheme -> AccessType in
                    switch scheme {
                    case .https, .http, .ftp:
                        return Remote(value: url.absoluteString)
                    default:
                        return url.scheme == nil
                            ? Remote(value: url.absoluteString)
                            : Deeplink(value: url.absoluteString)
                    }
                } (url
                    .scheme
                    .map(URL.Scheme.init(rawValue:)))
    }
}