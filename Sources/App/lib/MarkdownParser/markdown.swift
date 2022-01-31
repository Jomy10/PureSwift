//
//  File.swift
//  
//
//  Created by Jonas Everaert on 29/01/2022.
//

import MarkdownKit

func parse(readme: String) -> String {
    let markdown = MarkdownParser.standard.parse(readme)
    return HtmlGenerator().generate(doc: markdown)
}
