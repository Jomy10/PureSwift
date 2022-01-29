import Vapor
import NIO
import Foundation

enum PureSwiftError: Error {
    case Database(String)
    case DataDecode(String)
}

func routes(_ app: Application) throws {
    /// Index
    app.get { req -> EventLoopFuture<View> in
        // Get all packages
        let file = try String(contentsOfFile: "packages/packages.json", encoding: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let packages: [Package] = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!) 


        return req.view.render("index", ["packages": packages])
    }
    
    /// Packages
    app.get("package", ":name") { req -> EventLoopFuture<View> in
        
        let package_name = req.parameters.get("name")!
        
        let file = try String(contentsOfFile: "packages/packages.json", encoding: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let packages: [Package] = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!)
        
        if let package = packages.first(where: { $0.title == package_name }) {
            return req.view.render("package", package)
        } else {
            return req.view.render("package_not_found", ["title": package_name])
        }
    }
}
