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
        let modifiedHtml = try replace_img_urls(html: html)
        // Replace code class
        let modifiedHtml2 = try replace_code_class(html: modifiedHtml)

        return modifiedHtml2
    } catch {
        return html
    }
}

func replace_img_urls(html: String) throws -> String {
    let hrefRegex = try NSRegularExpression(pattern: "src=\"([a-zA-Z.]*)\"")
    let range = NSMakeRange(0, html.count)
    let modString = hrefRegex.stringByReplacingMatches(
        in: html, 
        options: [], 
        range: range, 
        withTemplate: "src=\"\(link)/master/$1\""
    )
    return modString
}

func replace_code_class(html: String) throws -> String {
    let classRegex = try NSRegularExpression(pattern: "class=\"([a-zA-Z_-]*)\"")
    let range = NSMakeRange(0, html.count)
    let modString = classRegex.stringByReplacingMatches(
        in: html, 
        options: [], 
        range: range,
        withTemplate: "class=\"language-$1\""
    )
    return modString
}