//
//  Log+Extension.swift
//  GoogleAdSample (iOS)
//
//  Created by Asaduzzaman Shuvro on 19/1/22.
//

import Foundation

public func log(object: Any? , function : String = #function, file: String = #file, lineNumber: Int = #line ) {
    
    #if DEBUG
    let lastFileName = (file.components(separatedBy: "/").last)?.components(separatedBy: ".").first
    print("\n\(lastFileName ?? "") [line -> \(lineNumber)] :: \(object ?? "")")
    #endif
}
