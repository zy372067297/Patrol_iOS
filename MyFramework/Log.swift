//
//  Log.swift
//  MyFramework
//
//  Created by JT on 2017/6/23.
//  Copyright © 2017年 JT. All rights reserved.
//
import Foundation

public func printLog<T>(message: T, file: String = #file, function: String = #function, line: Int = #line){

    //let fileName = (file as NSString).lastPathComponent
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateStr = dateFormat.string(from: Date())
    let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let logUrl = cachePath.appendingPathComponent("log.txt")
    //let logStr = dateStr + "|" + file + ":" + line + " " + function + "|" + message
    let logStr = "\(dateStr)|\(file) line:\(line) \(function)|\(message)"
    appendText(fileUrl: logUrl, str: logStr)
    print(logStr)
}

private func appendText(fileUrl : URL, str : String){
    do{
        if(!FileManager.default.fileExists(atPath: fileUrl.path)){
            FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
        }
        
        let fileHandle = try FileHandle(forWritingTo: fileUrl)
        let wstr = "\n" + str
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(wstr.data(using: String.Encoding.utf8)!)
    }
    catch let error as NSError{
        print(error)
    }
}
