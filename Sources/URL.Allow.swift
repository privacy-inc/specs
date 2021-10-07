import Foundation
import Domains

extension URL {
    enum Allow: String {
        case
        ecosia,
        google,
        youtube,
        instagram,
        twitter,
        reuters,
        thelocal,
        pinterest,
        facebook,
        bbc,
        reddit,
        spiegel,
        snapchat,
        linkedin,
        nyt,
        nytimes,
        medium,
        bloomberg,
        forbes,
        immobilienscout24,
        huffpost,
        giphy,
        theguardian
        
        var tld: Tld {
            switch self {
            case .ecosia:
                return .org
            case .google,
                 .youtube,
                 .instagram,
                 .twitter,
                 .reuters,
                 .pinterest,
                 .facebook,
                 .bbc,
                 .reddit,
                 .snapchat,
                 .linkedin,
                 .nyt,
                 .nytimes,
                 .medium,
                 .bloomberg,
                 .forbes,
                 .huffpost,
                 .giphy,
                 .theguardian:
                return .com
            case .thelocal,
                 .spiegel,
                 .immobilienscout24:
                return .de
            }
        }
        
        private var path: [Path] {
            switch self {
            case .google:
                return [.pagead,
                        .recaptcha,
                        .swg]
            case .facebook:
                return [.plugins,
                        .tr]
            case .reddit:
                return [.account]
            case .nyt:
                return [.ads]
            case .bloomberg:
                return [.subscription_offer]
            default:
                return []
            }
        }
        
        private var subdomain: [Subdomain] {
            switch self {
            case .twitter:
                return [.platform]
            case .spiegel:
                return [.interactive,
                        .tarifvergleich]
            case .snapchat:
                return [.tr]
            case .linkedin:
                return [.platform]
            case .google:
                return [.accounts,
                        .mobileads]
            case .bloomberg:
                return [.sourcepointcmp]
            case .immobilienscout24:
                return [.tracking]
            case .giphy:
                return [.cookies]
            case .theguardian:
                return [.sourcepoint]
            default:
                return []
            }
        }
        
        static func result(domain: Domain, url: URL) -> Policy.Result? {
            Self(rawValue: domain.name)
                .map { allow in
                    allow
                        .subdomain(domain: domain)
                    ?? allow
                        .path(domain: domain, url: url)
                    ?? .allow
                }
        }
        
        private func subdomain(domain: Domain) -> Policy.Result? {
            domain
                .prefix
                .last
                .flatMap { prefix in
                    subdomain
                        .map(\.rawValue)
                        .contains(prefix)
                    ? .block(prefix + "." + domain.minimal)
                    : nil
                }
        }
        
        private func path(domain: Domain, url: URL) -> Policy.Result? {
            url
                .path
                .components(separatedBy: "/")
                .dropFirst()
                .first
                .flatMap { component in
                    path
                        .map(\.rawValue)
                        .contains(component)
                    ? .block(domain.minimal + "/" + component)
                    : nil
                }
        }
    }
}
