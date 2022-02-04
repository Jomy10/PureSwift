import Vapor
#if os(Linux)
import FoundationNetworking
#endif

/// Package controller for `/packages/*`
final class PackagePageController {
    /// Package page
    func getPage(req: Request) throws -> EventLoopFuture<View> {
        req.logger.info("Retrieving package page for ...")
        let package_name = req.parameters.get("name") ?? "not found"
        req.logger.info("\(package_name)")
        
        // Get json file contents 
        let file = try String(contentsOfFile: "Public/Data/packages.json", encoding: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let packages: [Package] = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!)
        // req.logger.info("Got packages: \(packages)")

        // Search package in JSON file
        if var package = packages.first(where: { $0.title == package_name }) {
            if package.desc == nil {
                // Get readme from repo
                if package.repo != nil {
                    // Build readme link
                    var readme_link: String = package.repo!
                    readme_link = readme_link.replacingOccurrences(of: "https://github.com", with: "https://raw.githubusercontent.com")
                    let raw_user_content = readme_link
                    readme_link.append("/master/README.md")

                    
                    // Get content from link and append to desc
                    let contents = try String(contentsOf: URL(string: readme_link) ?? URL(string: "Public/NOTFOUND.md")!)

                    // Build HTML
                    package.desc = parse(readme: contents, link: raw_user_content)
                }
            }
            return req.view.render("package", package)
        } else {
            return req.view.render("package_not_found", ["title": package_name])
        }
    }
}

