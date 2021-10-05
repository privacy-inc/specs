import Foundation

extension Array where Element == Blocker.Rule {
    var compress: Self {
        self
            .filter {
                $0.trigger == .all || $0.trigger == .script
            }
        + self
            .filter {
                $0.trigger != .all && $0.trigger != .script
            }
            .reduce(into: [URL.Allow : Set<String>]()) {
                if case let .css(css) = $1.action,
                   case let .url(url) = $1.trigger {
                    $0[url, default: []].formUnion(css)
                }
            }
            .map {
                .init(trigger: .url($0.0), action: .css($0.1))
            }
    }
    
    var content: String {
        "[" + map {
            """
{
    "action": {
        \($0.action.content)
    },
    "trigger": {
        \($0.trigger.content)
    }
}
"""
        }
        .joined(separator: ",") + "]"
    }
}

private extension Blocker.Rule.Action {
    var content: String {
        switch self {
        case .cookies:
            return """
"type": "block-cookies"
"""
        case .http:
            return """
"type": "make-https"
"""
        case .block:
            return """
"type": "block"
"""
        case let .css(css):
            return """
"type": "css-display-none",
"selector": "\(css.joined(separator: ", "))"
"""
        }
    }
}

private extension Blocker.Rule.Trigger {
    var content: String {
        switch self {
        case .all:
            return """
"url-filter": ".*"
"""
        case .script:
            return """
"url-filter": ".*",
"load-type": ["third-party"],
"resource-type": ["script"]
"""
        case let .url(url):
            return """
"url-filter": "^https?://+([^:/]+\\\\.)?\(url.rawValue)\\\\.\(url.tld)[:/]",
"url-filter-is-case-sensitive": true,
"if-domain": ["*\(url.rawValue).\(url.tld.rawValue)"],
"load-type": ["first-party"],
"resource-type": ["document"]
"""
        }
    }
}
