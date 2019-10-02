//
//  TextFormat.swift
//  iguitar
//
//  Created by Up Devel on 30/09/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation

class TextFormat {
    
    func formatToHTML(text: String) -> String {
        
        let arrStrings  = text.split(separator: "\n")
        var formatedText = "<br>"
        
        for i in 0..<arrStrings.count {
         //  formatedText.append(String(arrStrings[i]))
            print(i)
            print(format(line: String(arrStrings[i])))
            }
            
            
        
        
        return formatedText
    }
    
    private func format(line: String) -> String {
        var upLine = ""
        var hasAckords = false
           var startInd = 0
        for i in line.indices {
         
            
            if (line[i] == "<") {
                let endInd = i.hashValue
                let countReapet = endInd - startInd
                print(startInd)
                print(endInd)
                print(countReapet)
                upLine.append(String(repeating: " ", count: countReapet))
            
                for j  in line.substring(from: i).indices {
                    
                    if (line[j] == ">") {
                        startInd = j.hashValue
                        let charsAckkord = line.index(i, offsetBy: j.hashValue)
                        upLine.append(line[charsAckkord] )
                        hasAckords = true
                    }
                    
                }

            }
            
        }
        if (hasAckords) {
            upLine.append("<br>")
            upLine.append(line)
        }
      
        return upLine
    }
    
}
