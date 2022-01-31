import Leaf
import Vapor
import Foundation

/// The firebase token
public var firebase_token: EventLoopFuture<ClientResponse>?
// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)
    
    // app.console.progressBar(title: String)
        
    // register routes
    try routes(app)
}
