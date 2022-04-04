import Foundation

public enum Router: Equatable {
    case
    remote,
    deeplink,
    local(Data),
    embed(Policy.Response)
    
    public static func with(url: URL) -> Router {
        url.isFileURL
        ? .local(url.deletingLastPathComponent().bookmark)
            : url
                .scheme
                .flatMap(URL.Embed.init(rawValue:))
                .map(\.response)
                .map(embed)
                ?? { scheme -> Self in
                    switch scheme {
                    case .https, .http, .ftp:
                        return .remote
                    default:
                        return url.scheme == nil
                            ? .remote
                            : .deeplink
                    }
                } (url
                    .scheme
                    .map(URL.Scheme.init(rawValue:)))
    }
}
