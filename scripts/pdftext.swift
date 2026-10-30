// macOS PDFKit 文本抽取（无 pdftotext 时的兜底）
// 用法: swift pdftext.swift <file.pdf>
import Foundation
import PDFKit

let args = CommandLine.arguments
guard args.count > 1 else {
    FileHandle.standardError.write("usage: swift pdftext.swift <file.pdf>\n".data(using: .utf8)!)
    exit(2)
}

let url = URL(fileURLWithPath: args[1])
guard let doc = PDFDocument(url: url) else {
    FileHandle.standardError.write("ERROR: cannot open PDF\n".data(using: .utf8)!)
    exit(3)
}

for i in 0..<doc.pageCount {
    if let page = doc.page(at: i), let text = page.string {
        print("===PAGE \(i + 1)===")
        print(text)
    }
}
