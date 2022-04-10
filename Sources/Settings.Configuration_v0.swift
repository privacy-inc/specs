import Foundation
import Archivable

#warning("sunset")

extension Settings_v0 {
    struct Configuration_v0: Storable, Equatable {
        var autoplay: Settings.Autoplay
        var javascript: Bool
        var popups: Bool
        var location: Bool
        var timers: Bool
        var dark: Bool
        var ads: Bool
        var screen: Bool
        var cookies: Bool
        var http: Bool
        var third: Bool
        
        var data: Data {
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
        
        init(data: inout Data) {
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
        }
    }
}
