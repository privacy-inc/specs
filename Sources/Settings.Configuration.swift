import Foundation
import Archivable

extension Settings {
    public struct Configuration: Storable, Equatable {
        public internal(set) var autoplay: Autoplay
        public internal(set) var javascript: Bool
        public internal(set) var popups: Bool
        public internal(set) var location: Bool
        public internal(set) var timers: Bool
        public internal(set) var dark: Bool
        public internal(set) var ads: Bool
        public internal(set) var screen: Bool
        public internal(set) var cookies: Bool
        public internal(set) var http: Bool
        public internal(set) var third: Bool
        public internal(set) var history: Bool
        public internal(set) var favicons: Bool
        
        public var scripts: String {
            (screen ? "" : Script.scroll)
            + (timers ? "" : Script.timers)
            + Script.basic
        }
        
        public var data: Data {
            .init()
            .adding(autoplay.rawValue)
            .adding(javascript)
            .adding(popups)
            .adding(location)
            .adding(timers)
            .adding(dark)
            .adding(ads)
            .adding(screen)
            .adding(cookies)
            .adding(http)
            .adding(third)
            .adding(history)
            .adding(favicons)
        }
        
        public init(data: inout Data) {
            autoplay = .init(rawValue: data.number())!
            javascript = data.bool()
            popups = data.bool()
            location = data.bool()
            timers = data.bool()
            dark = data.bool()
            ads = data.bool()
            screen = data.bool()
            cookies = data.bool()
            http = data.bool()
            third = data.bool()
            history = data.bool()
            favicons = data.bool()
        }
        
        init() {
            autoplay = .none
            javascript = true
            popups = false
            location = false
            timers = true
            dark = true
            ads = false
            screen = false
            cookies = false
            http = false
            third = true
            history = true
            favicons = true
        }
        
        public func blockers(dark: Bool) -> String {
            blockList(dark: dark)
                .rules
        }
        
        func blockList(dark: Bool) -> Set<Blocker> {
            var rules = Set<Blocker>()
            
            if !cookies {
                rules.insert(.cookies)
            }
            
            if !http {
                rules.insert(.http)
            }
            
            if !ads {
                rules.insert(.ads)
            }
            
            if !screen {
                rules.insert(.screen)
            }
            
            if !third {
                rules.insert(.third)
            }
            
            if self.dark && dark {
                rules.insert(.antidark)
            }
            
            return rules
        }
    }
}
