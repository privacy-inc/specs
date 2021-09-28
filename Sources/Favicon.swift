import Foundation
import Combine

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS) || os(iOS)

public final actor Favicon {
    private var received = Set<String>()
    private var publishers = [String : Pub]()
    
    nonisolated private let session: URLSession = {
        var configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        return .init(configuration: configuration)
    } ()
    
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
    
    public func publisher(for access: AccessType) -> Pub? {
        guard let domain = (access as? Access.Remote)?.domain else { return nil }
        
        validate(domain: domain)
        
        print("pubs \(publishers.count)")
        
        let publisher = publishers[domain]!
        
        Task
            .detached(priority: .utility) {
                if await publisher.output == nil {
                    guard let output = await self.output(for: domain) else { return }
                    await publisher.received(output: output)
                }
            }
        
        return publisher
    }
    
    public func request(for access: AccessType) -> Bool {
        (access as? Access.Remote)
            .map {
                !received.contains($0.domain) && !$0.domain.isEmpty
            }
        ?? false
    }
    
    public func received(url: String, for access: AccessType) async {
        guard let domain = (access as? Access.Remote)?.domain else { return }
        
        validate(domain: domain)
        received.insert(domain)
        
        print("pubs \(publishers.count)")
        
        guard
            !url.isEmpty,
            let url = URL(string: url)
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
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        
        try? FileManager.default.moveItem(at: location, to: path.appendingPathComponent(domain))
        
        guard let output = output(for: domain) else { return }
        await publishers[domain]!.received(output: output)
    }
    
    private func validate(domain: String) {
        if publishers[domain] == nil {
            publishers[domain] = .init()
        }
    }
    
    private func output(for domain: String) -> Pub.Output? {
        let url = path.appendingPathComponent(domain)
        
        guard
            FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url)
        else { return nil }
        
        return .init(data: data)
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
        fileprivate private(set) var output: Output?
        private var contracts = [Contract]()
        
        fileprivate func received(output: Output) async {
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
            Swift.print("cleaning")
            
            contracts = contracts
                .filter {
                    $0.sub?.subscriber != nil
                }
        }
    }
}
    
private extension Favicon.Pub {
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
