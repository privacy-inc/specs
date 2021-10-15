import Foundation
import Archivable

extension Settings {
    public struct Configuration: Storable, Equatable {
        public let autoplay: Autoplay
        public let javascript: Bool
        public let popups: Bool
        public let location: Bool
        public let timers: Bool
        public let dark: Bool
        public let ads: Bool
        public let screen: Bool
        public let cookies: Bool
        public let http: Bool
        public let third: Bool
        
        public var scripts: String {
            (screen ? "" : Script.scroll)
            + (timers ? "" : Script.timers)
        }
        
        public var blockers: String {
            _blockers
                .rules
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
        }
        
        var _blockers: Set<Blocker> {
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
            
            if dark {
                rules.insert(.antidark)
            }
            
            if !third {
                rules.insert(.third)
            }
            
            return rules
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
        }
        
        init() {
            self.init(
                autoplay: .none,
                javascript: true,
                popups: false,
                location: false,
                timers: true,
                dark: true,
                ads: false,
                screen: false,
                cookies: false,
                http: false,
                third: true)
        }
        
        private init(autoplay: Autoplay,
                     javascript: Bool,
                     popups: Bool,
                     location: Bool,
                     timers: Bool,
                     dark: Bool,
                     ads: Bool,
                     screen: Bool,
                     cookies: Bool,
                     http: Bool,
                     third: Bool) {
            self.autoplay = autoplay
            self.javascript = javascript
            self.popups = popups
            self.location = location
            self.timers = timers
            self.dark = dark
            self.ads = ads
            self.screen = screen
            self.cookies = cookies
            self.http = http
            self.third = third
        }
        
        func with(autoplay: Autoplay) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(javascript: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(popups: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(location: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(timers: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(dark: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(ads: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(screen: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(cookies: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(http: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
        
        func with(third: Bool) -> Self {
            .init(autoplay: autoplay,
                  javascript: javascript,
                  popups: popups,
                  location: location,
                  timers: timers,
                  dark: dark,
                  ads: ads,
                  screen: screen,
                  cookies: cookies,
                  http: http,
                  third: third)
        }
    }
}
