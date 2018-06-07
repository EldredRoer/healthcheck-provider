@testable import Vapor
@testable import HealthcheckProvider
import XCTest
import Testing

extension Droplet {
    static func testable() throws -> Droplet {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "healthcheck")
        try! config.addProvider(HealthcheckProvider.Provider.self)
        return try Droplet(config)
    }
    func serveInBackground() throws {
        background {
            try! self.run()
        }
    }
}

class ProviderTests: XCTestCase {
    let drop = try! Droplet.testable()
    
    override func setUp() {
        Testing.onFail = XCTFail
    }
    
    func testHealthcheck() {
        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .ok)
            .assertJSON("status", equals: "up")
    }
    
    func testHealthcheckFail() {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "")
        try! config.addProvider(HealthcheckProvider.Provider.self)
        let drop = try! Droplet(config)
        background {
            try! drop.run()
        }
        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .notFound)
    }
    
    
    static var allTests = [
        ("testHealthcheck", testHealthcheck),
        ("testHealthcheckFail", testHealthcheckFail),
        ]
}
