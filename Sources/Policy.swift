import Foundation

public enum Policy: UInt8 {
    case
    secure,
    standard
    
    static func with(data: inout Data) -> PolicyLevel {
        switch Self(rawValue: data.removeFirst())! {
        case .secure:
            return Secure()
        case .standard:
            return Standard()
        }
    }
}
