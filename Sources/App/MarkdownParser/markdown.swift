//
//  File.swift
//  
//
//  Created by Jonas Everaert on 29/01/2022.
//

import Foundation

func swift_greet() {
    
}

/*
/// Parses markdown string to HTML
func parse_md(_ s: String) -> HTML {
    var output: HTML = HTML()
    let md = Document(parsing: s)
    // print(md.debugDescription())
    for child in md.children {
        output.append(parse_node(node: child))
    }
    
    return output
}

func parse_node(node: Markup) -> HTMLElement {
    // print(node.debugDescription)
    // Generate HTML
    if node is BlockQuote {
        // TODO: fix; not converted to HTML correctly
        let b: BlockQuote = node as! BlockQuote
        var children: [HTMLElement] = []
        for child in b.blockChildren {
            children.append(contentsOf: parse_node(node: child).body)
        }
        return HTMLBlockquote(children: children)
        // html.append("<blockquote>\(b)</blockquote>")
    } else if node is CodeBlock {
        let b: CodeBlock = node as! CodeBlock
        return HTMLSpan(child: HTMLCode(b.code))
    } else if node is CustomBlock {
        let b: CustomBlock = node as! CustomBlock
        print("[i: MD] CustomBlock is not implemented")
        return Paragraph("")
    } else if node is Document {
        let b: Document = node as! Document
        var html: HTML = HTML()
        for child in b.children {
            html.append(parse_node(node: child))
        }
        return html
    } else if node is Heading {
        let h: Heading = node as! Heading
        return HTMLHeader(type: h.level, h.plainText)
    } else if node is ThematicBreak {
        print("[i: MD] ThematicBreak is not implemented")
        print(Paragraph(""))
    } else if node is HTMLBlock {
        let h: HTMLBlock = node as! HTMLBlock
        return HTMLCustomElement(h.rawHTML)
    } else if node is ListItem {
        let l: ListItem = node as! ListItem
        print("ListItem:", l)
        var html = HTML()
        // TODO
        print(html)
        return html
    } else if node is OrderedList {
        let o: OrderedList = node as! OrderedList
        print(o.debugDescription())
        var children: [HTMLElement] = []
        o.children.forEach { child in
            children.append(contentsOf: parse_node(node: child).children)
        }
        return HTMLOrderedList(children: children)
    } else if node is UnorderedList {
        let o: UnorderedList = node as! UnorderedList
        print(o.debugDescription())
        var children: [HTMLElement] = []
        o.children.forEach { child in
            children.append(contentsOf: parse_node(node: child).children)
        }
        return HTMLUnorderedList(children: children)
    } else if node is Paragraph {
        let p: Paragraph = node as! Paragraph
        return HTMLParagraph(p.plainText)
    } else if node is BlockDirective {
        
    } else if node is InlineCode {
        
    } else if node is CustomInline {
        
    } else if node is Emphasis {
        
    } else if node is Image {
        
    } else if node is InlineHTML {
        
    } else if node is LineBreak {
        
    } else if node is Link {
        
    } else if node is SoftBreak {
        
    } else if node is Strong {
        
    } else if node is Text {
        
    } else if node is Strikethrough {
        
    } else if node is Table {
        
    } else if node is Table.Row {
        
    } else if node is Table.Head {
        
    } else if node is Table.Body {
        
    } else if node is Table.Cell {
        
    } else if node is SymbolLink {
        
    }
    
    return HTML()
}

*/