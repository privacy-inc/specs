import Foundation
import Combine

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS) || os(iOS)

public final actor Favicon {
    private(set) var received = Set<String>()
    private(set) var publishers = [String : Pub]()
    nonisolated private let session = URLSession(configuration: .background(withIdentifier: ""))
    
    private lazy var path: URL = {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favicons")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return url
    } ()
    
    public init() {
        
    }
    
    public func publisher(for domain: String) -> Pub {
        validate(domain: domain)
        
        print("pubs \(publishers.count)")
        
        let publisher = publishers[domain]!
        let url = path.appendingPathComponent(domain)
        
        Task
            .detached(priority: .utility) {
                if await publisher.output == nil {
                    guard
                        FileManager.default.fileExists(atPath: url.path),
                        let output = (try? Data(contentsOf: url)).flatMap(Pub.Output.init(data:))
                    else { return }
                    await publisher.received(output: output)
                }
            }
        
        return publisher
    }
    
    public func received(url: String, for domain: String) async {
        validate(domain: domain)
        received(domain: domain)
        
        print("pubs \(publishers.count)")
        
        guard
            !domain.isEmpty,
            !url.isEmpty,
            let url = URL(string: url),
            await publishers[domain]!.output == nil
        else { return }
        
        Task
            .detached(priority: .utility) {
                try? await self.fetch(url: url, for: domain)
            }
    }
    
    public func clear() {
        publishers = [:]
        received = []
        let path = self.path
        
        Task
            .detached(priority: .utility) {
                try? FileManager.default.removeItem(at: path)
            }
    }
    
    private func fetch(url: URL, for domain: String) async throws {
        let (location, response) = try await session.download(from: url)
        
        guard
            (response as? HTTPURLResponse)?.statusCode == 200,
            let data = try? Data(contentsOf: location),
            let output = Pub.Output.init(data: data)
        else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        
        try? FileManager.default.moveItem(at: location, to: path.appendingPathComponent(domain))
        await publishers[domain]!.received(output: output)
    }
    
    private func validate(domain: String) {
        if publishers[domain] == nil {
            publishers[domain] = .init()
        }
    }
    
    private func received(domain: String) {
        received.insert(domain)
    }
}

extension Favicon {
    public final actor Pub: Publisher {
#if os(macOS)
public typealias Output = NSImage
#elseif os(iOS)
public typealias Output = UIImage
#endif

        public typealias Failure = Never
        private(set) var output: Output?
        private(set) var contracts = [Contract]()
        
        func received(output: Output) async {
            self.output = output
            await send(output: output)
        }
        
        public nonisolated func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let sub = Sub(subscriber: .init(subscriber))
            subscriber.receive(subscription: sub)
            
            Task {
                await store(contract: .init(sub: sub))
            }
        }
        
        private func store(contract: Contract) async {
            contracts.append(contract)
            
            Swift.print("pub contracts \(contracts.count)")
            
            clean()
            if let output = output {
                await MainActor
                    .run {
                        _ = contract.sub?.subscriber?.receive(output)
                    }
            }
        }
        
        private func send(output: Output) async {
            clean()
            let subscribers = contracts.compactMap(\.sub?.subscriber)
            await MainActor
                .run {
                    subscribers
                        .forEach {
                            _ = $0.receive(output)
                        }
                }
        }
        
        private func clean() {
            contracts = contracts
                .filter {
                    $0.sub?.subscriber != nil
                }
        }
    }
}
    
extension Favicon.Pub {
    final class Sub: Subscription {
        private(set) var subscriber: AnySubscriber<Output, Failure>?
        
        init(subscriber: AnySubscriber<Output, Failure>) {
            self.subscriber = subscriber
        }
        
        func cancel() {
            subscriber = nil
        }
        
        func request(_: Subscribers.Demand) {

        }
    }
    
    struct Contract {
        private(set) weak var sub: Sub?
        
        init(sub: Sub) {
            self.sub = sub
        }
    }
}

#endif
