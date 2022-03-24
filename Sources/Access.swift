import Foundation
import Archivable

public enum Access: UInt8 {
    case
    remote,
    local,
    deeplink,
    embed
    
    static func with(data: inout Data) -> any AccessType {
        switch Self(rawValue: data.removeFirst())! {
        case .remote:
            return Remote(value: data.string(size: UInt16.self))
        case .local:
            return Local(value: data.string(size: UInt16.self), bookmark: data.unwrap(size: UInt16.self))
        case .deeplink:
            return Other(key: .deeplink, value: data.string(size: UInt16.self))
        case .embed:
            return Other(key: .embed, value: data.string(size: UInt16.self))
        }
    }
    
    static func with(url: URL) -> any AccessType {
        url.isFileURL
            ? Local(value: url.absoluteString, bookmark: url.deletingLastPathComponent().bookmark)
            : url
                .scheme
                .flatMap(URL.Embed.init(rawValue:))
                .map { _ in
                    Other(key: .embed, value: url.absoluteString)
                }
                ?? { scheme -> any AccessType in
                    switch scheme {
                    case .https, .http, .ftp:
                        return Remote(value: url.absoluteString)
                    default:
                        return url.scheme == nil
                            ? Remote(value: url.absoluteString)
                            : Other(key: .deeplink, value: url.absoluteString)
                    }
                } (url
                    .scheme
                    .map(URL.Scheme.init(rawValue:)))
    }
}
