import Foundation
import Archivable

public enum Access: Storable {
    case
    remote(Remote),
    local(Local),
    deeplink(Deeplink),
    embed(Embed)
    
    public var data: Data {
        Data()
            .adding(key.rawValue)
            .adding(content)
    }
    
    public init(data: inout Data) {
        switch Key(rawValue: data.removeFirst())! {
        case .remote:
            self = .remote(.init(value: data.string()))
        case .local:
            self = .local(.init(value: data.string(), bookmark: data.unwrap()))
        case .deeplink:
            self = .deeplink(.init(value: data.string()))
        case .embed:
            self = .embed(.init(value: data.string()))
        }
    }
    
    init(url: URL) {
        self = url.isFileURL
            ? .local(.init(value: url.absoluteString, bookmark: url.deletingLastPathComponent().bookmark))
            : url
                .scheme
                .flatMap(URL.Embed.init(rawValue:))
                .map { _ in
                    .embed(.init(value: url.absoluteString))
                }
                ?? {
                    switch $0 {
                    case .https, .http, .ftp:
                        return .remote(.init(value: url.absoluteString))
                    default:
                        return url.scheme == nil
                            ? .remote(.init(value: url.absoluteString))
                            : .deeplink(.init(value: url.absoluteString))
                    }
                } (url
                    .scheme
                    .map(URL.Scheme.init(rawValue:)))
    }
    
    private var content: Data {
        switch self {
        case let .remote(remote):
            return Data()
                .adding(remote.value)
        case let .local(local):
            return Data()
                .adding(local.value)
                .wrapping(local.bookmark)
        case let .deeplink(deeplink):
            return Data()
                .adding(deeplink.value)
        case let .embed(embed):
            return Data()
                .adding(embed.value)
        }
    }
}
