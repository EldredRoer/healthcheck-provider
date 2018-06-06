import Vapor
public final class Provider: Vapor.Provider {
    public static let repositoryName: String = "healthCheck.provider"
    //holds the route for endpoint
    public var healthCheckUrl: String?
    
    public init(config: Config) throws {
        if let healthCheckUrl = config["healthCheck", "url"]?.string {
            self.healthCheckUrl = healthCheckUrl
        }
    }
    
    //called after the Provider has been initialized
    public func boot(_ config: Config) throws {}
    
    // healthcheck route defined here
    public func boot(_ drop: Droplet) {
        guard let healthCheckUrl = self.healthCheckUrl else {
            return drop.console.warning("MISSING: healthcheck.json config in Config folder. Healthcheck URL not addded.")
        }
        
        drop.get(healthCheckUrl) { req in
            return try Response(status: .ok, json: JSON(["status": "up"]))
        }
        
    }
    
    // called before droplet is run
    public func beforeRun(_ drop: Droplet) {}
}
