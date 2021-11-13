import Foundation

extension Script {
    static let _location = """
navigator.geolocation.getCurrentPosition = async function(success, error, options) {
    var promise = webkit.messageHandlers.\(Script.location.method).postMessage("\(Script.location.method)");
    await promise;

    if (success != null, promise != null) {
        var position = {
           coords: {
               latitude: promise[0],
               longitude: promise[1],
               accuracy: promise[2]
           }
        };
        success(position);
    }
};

"""
}
