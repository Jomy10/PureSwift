import Foundation
import Vapor

/// Represents a package  as defined in `Public/Data/packages.json`
struct Package: Content {
    /// Title of the packagge
    var title: String
    /// A list of authors
    var authors: [String]?
    /// A short description of the package
    var short_desc: String?
    /// Overrides the readme file of the repo, not recommended
    var desc: String?
    /// A list of licenses (e.g "MIT", "Apacha-2.0", ...)
    /// Please use the `SPDX short identifier` provided on [opensourcelicense.org](https://opensource.org/licenses).
    /// Click on one of the licenses and you'll see it. Otherwise use the full name
    /// (example: https://opensource.org/licenses/MIT -> "MIT"). If the license is not listed on the website, 
    /// just use the name provided by the package
    var license: [String]? 
    /// A link to the doumentation
    var docs: String?
    /// A link to the homepage (if any)
    var homepage: String?
    /// Used to fetch a `desc`. Currently only supports GitHub, 
    /// but feel free to add support for other git services by opening a pull request
    /// Should  be of this form (example for Vapor): `https://github.com/vapor/vapor`
    var repo: String?
    /// See Categories.md for a list
    var categories: [String]?
    /// The date it was added on
    var addedTime: Date?
}
