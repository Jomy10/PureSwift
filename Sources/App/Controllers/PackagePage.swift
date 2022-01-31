import Vapor

/*
final class PackagePageController {
    func getPage(req: Request) throws -> EventLoopFuture<View> {
        return try PackageHTML().render(with: req)
    }
}
*/

final class PackagePageController {
    func getPage(req: Request) throws -> EventLoopFuture<View> {
        let package_name = req.parameters.get("name")!
        
        let file = try String(contentsOfFile: "Data/packages.json", encoding: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let packages: [Package] = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!)

        // return PackagePageController().getPage(req: req) 
        // Search package in JSON file
        if var package = packages.first(where: { $0.title == package_name }) {
            if package.desc == nil {
                // Get readme from repo
                if package.repo != nil {
                    var readme_link: String = package.repo!
                    readme_link = readme_link.replacingOccurrences(of: "https://github.com", with: "https://raw.githubusercontent.com")
                    // readme_link = readme_link?.replacingOccurrences(of: ".git", with: "")
                    readme_link.append("/master/README.md")
                    
                    // Get content from link and append to desc
                    let contents = try String(contentsOf: URL(string: readme_link)!)
                    
                    // TODO: parse markdown using Apple's Swift Markdown
                    // package.desc = parse_md(contents)
                    // package.desc = (build html from markdown)
                    package.desc = parse(readme: contents)
                }
            }
            return req.view.render("package", package)
        } else {
            return req.view.render("package_not_found", ["title": package_name])
        }
    }
}