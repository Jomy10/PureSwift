//
//  markdown.swift
// 
//  Parsing markdown to html
//
//  Created by Jonas Everaert on 29/01/2022.
//

import MarkdownKit
import Foundation

// Parses markdown to html using MarkdownKit
func parse(readme: String, link: String) -> String {
    let markdown = MarkdownParser.standard.parse(readme)
    let html = HtmlGenerator().generate(doc: markdown)
    // Replace image links
    do {
        let hrefRegex = try NSRegularExpression(pattern: "src=\"([a-zA-Z.]*)\"")
        let range = NSMakeRange(0, html.count)
        let modString = hrefRegex.stringByReplacingMatches(
            in: html, 
            options: [], 
            range: range, 
            withTemplate: "src=\"\(link)/master/$1\""
        )
        return modString
    } catch {
        return html
    }
    return html
}