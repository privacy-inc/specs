import Foundation
import Domains

extension URL {
    enum Allow: String, CaseIterable {
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
        giphy
        
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
                 .giphy:
                return .com
            case .thelocal,
                 .spiegel,
                 .immobilienscout24:
                return .de
            }
        }
        
        var path: [Path] {
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
        
        var subdomain: [Subdomain] {
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
            default:
                return []
            }
        }
    }
}
