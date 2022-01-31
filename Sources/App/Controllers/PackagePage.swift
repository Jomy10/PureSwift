import Vapor
import MarkdownKit


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
        req.logger.info("Got packages: \(packages)")

        // Search package in JSON file
        if var package = packages.first(where: { $0.title == package_name }) {
            if package.desc == nil {
                // Get readme from repo
                if package.repo != nil {
                    req.logger.info("Parsing readme link")
                    // Build readme link
                    var readme_link: String = package.repo!
                    readme_link = readme_link.replacingOccurrences(of: "https://github.com", with: "https://raw.githubusercontent.com")
                    readme_link.append("/master/README.md")

                    req.logger.info("Readme link parser.")
                    
                    // Get content from link and append to desc
                    req.logger.info("Reading readme...")
                    let contents = try String(contentsOf: URL(string: readme_link) ?? URL(string: "LINK TO NOT FOUND MARKDOWN")!)
                    req.logger.info("Readme contents: \(contents)")

                    // Build HTML
                    req.logger.info("Building html...")
                    package.desc = parse(readme: contents)
                    req.logger.info("HTML build: \(String(describing: package.desc))")
                }
            }
            return req.view.render("package", package)
        } else {
            return req.view.render("package_not_found", ["title": package_name])
        }
    }
}

/// Parses markdown to html using MarkdownKit
func parse(readme: String) -> String {
    let markdown = MarkdownParser.standard.parse(readme)
    return HtmlGenerator().generate(doc: markdown)
}