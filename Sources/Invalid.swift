import Foundation

public enum Invalid: Int, Error {
    case
    search,
    url,
    urlCantBeShown = 101,
    frameLoadInterrupted = 102
}
