import Foundation
import Archivable

extension Settings {
    public struct Configuration: Storable {
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
        
        public var scripts: Scripts {
            .init(start: "", end: "")
        }
        
        public var blocking: String {
            ""
        }
        
        public var data: Data {
            .init()
        }
        
        public init(data: inout Data) {
            fatalError()
        }
        
        init() {
            fatalError()
        }
        
        private init(autoplay: Autoplay, javascript: Bool, popups: Bool, location: Bool, timers: Bool, dark: Bool, ads: Bool, screen: Bool, cookies: Bool, http: Bool, third: Bool) {
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
        
        
        
        
        /*
        
        
        
        
        
        
        
        
        public internal(set) var engine: Engine
        public internal(set) var javascript: Bool
        public internal(set) var popups: Bool
        public internal(set) var location: Bool
        public internal(set) var timers: Bool
        private(set) var router: Router
        private(set) var blocking: Set<Blocker>
        
        public var dark: Bool {
            didSet {
                if dark {
                    blocking.insert(.antidark)
                } else {
                    blocking.remove(.antidark)
                }
            }
        }
        
        public internal(set) var ads: Bool {
            didSet {
                if ads {
                    blocking.remove(.ads)
                } else {
                    blocking.insert(.ads)
                }
            }
        }
        
        public internal(set) var screen: Bool {
            didSet {
                if screen {
                    blocking.remove(.screen)
                } else {
                    blocking.insert(.screen)
                }
            }
        }
        
        public internal(set) var cookies: Bool {
            didSet {
                if cookies {
                    blocking.remove(.cookies)
                } else {
                    blocking.insert(.cookies)
                }
            }
        }
        
        public internal(set) var http: Bool {
            didSet {
                if http {
                    blocking.remove(.http)
                } else {
                    blocking.insert(.http)
                }
            }
        }
        
        public internal(set) var third: Bool {
            didSet {
                if third {
                    blocking.remove(.third)
                } else {
                    blocking.insert(.third)
                }
            }
        }
        
        public internal(set) var trackers: Bool {
            didSet {
                router = trackers.router
            }
        }
        
        public var data: Data {
            fatalError()
        }
        
        var pre: Data {
            Data()
                .adding(engine.data)
                .adding(javascript)
                .adding(dark)
                .adding(popups)
                .adding(ads)
                .adding(screen)
                .adding(trackers)
                .adding(cookies)
                .adding(http)
                .adding(location)
        }
        
        var post: Data {
            Data()
                .adding(third)
                .adding(timers)
        }
        
        public init(data: inout Data) {
            engine = .init(data: &data)
            javascript = data.bool()
            dark = data.bool()
            popups = data.bool()
            ads = data.bool()
            screen = data.bool()
            trackers = data.bool()
            cookies = data.bool()
            http = data.bool()
            location = data.bool()
            third = data.bool()
            timers = data.isEmpty ? true : data.bool()
            router = trackers.router
            blocking = []
            
            if dark {
                blocking.insert(.antidark)
            }
            
            if !ads {
                blocking.insert(.ads)
            }
            
            if !screen {
                blocking.insert(.screen)
            }
            
            if !cookies {
                blocking.insert(.cookies)
            }
            
            if !http {
                blocking.insert(.http)
            }
            
            if !third {
                blocking.insert(.third)
            }
        }
        
        init() {
            engine = .google
            javascript = true
            dark = true
            popups = false
            ads = false
            screen = false
            trackers = false
            cookies = false
            http = false
            location = false
            third = true
            timers = true
            router = .secure
            blocking = .init(Blocker
                                .allCases
                                .filter {
                                    $0 != .third
                                })
        }
        
        public var rules: String {
            blocking.rules
        }
        
        public var start: String {
            dark
                ? Script.dark + Script.favicon
                : Script.favicon
        }
        
        public var end: String {
            (screen ? "" : Script.scroll)
            + (location ? Script.location : "")
                + (timers ? "" : Script.timers)
        }
        
        public static func == (lhs: Settings, rhs: Settings) -> Bool {
            lhs.engine == rhs.engine
                && lhs.javascript == rhs.javascript
                && lhs.dark == rhs.dark
                && lhs.popups == rhs.popups
                && lhs.ads == rhs.ads
                && lhs.screen == rhs.screen
                && lhs.trackers == rhs.trackers
                && lhs.cookies == rhs.cookies
                && lhs.http == rhs.http
                && lhs.location == rhs.location
                && lhs.third == rhs.third
                && lhs.timers == rhs.timers
        }
         
         */
    }
}
