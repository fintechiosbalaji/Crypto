//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Rockz on 24/12/24.
//

import Foundation
import SwiftUI

class LocalFileManager{
    
    static let instance = LocalFileManager()
    private let cachePathName:String = "MyImages"
    
    private init(){
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded(){
        guard
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(cachePathName)
                .path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path){
            do{
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true,attributes: nil)
                print("SUCCESS CREATING FOLDER")
            }catch let error{
                print("ERROR CREATING DIRECTORY")
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFolder() -> String{
        guard
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(cachePathName)
                .path else {
            return "ERROR GETTING PATH"
        }
        
        do{
            try FileManager.default.removeItem(atPath: path)
            return "SUCCESS DELETING FOLDER"
        }catch let error{
            print(error.localizedDescription)
            return "ERROR DELETING FOLDER"
        }
    }
    
    func saveImage(image:UIImage,name:String) -> String{
        
        guard let data = image.pngData(),let path = getPathForImage(name: name) else {
            return "ERROR GETTING PATH"
        }
        
        do{
            try data.write(to: path)
            return "SUCCESS SAVING"
        }catch let error{
            print(error.localizedDescription)
            return "ERROR SAVING IMAGE"
        }
    }
    
    func loadImage(name:String) -> UIImage?{
        
        guard let path  = getPathForImage(name: name)?.path,FileManager.default.fileExists(atPath: path) else{
            print("ERROR GETTTING PATH")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(image:UIImage,name:String) -> String{
        guard
            let path = getPathForImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
            return "ERROR GETTING PATH"
        }
        
        do {
            try FileManager.default.removeItem(at: path)
        }catch let error{
            print(error.localizedDescription)
            return "ERROR DELETING IMAGE"
        }
        return "SUCCESS DELETING IMAGE"
    }
    
    func getPathForImage(name:String) -> URL?{
        
        guard
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
                .appendingPathComponent(cachePathName)
                .appendingPathComponent("\(name).png") else {
            return nil
        }
        return path
    }
}

class LocalFMViewModel:ObservableObject{
    //MARK: - Properties
    let manager = LocalFileManager.instance
    @Published var image:UIImage? = nil
    @Published var infoMessage:String = ""
    var infoMessageColor = Color.black
    var imageName:String = ""
    
    init(){}
    
    func getImageFromeFileManager(){
        if let image = manager.loadImage(name: imageName){
            infoMessage = "SUCCESS LOADING FM"
            infoMessageColor = .green
            self.image = image
        }else{
            infoMessage = "ERROR GETTING FM"
            infoMessageColor = .pink
        }
    }
    
    func getImageFromAssetFolder(){
        if let image = UIImage(named: imageName){
            infoMessage = "SUCCESS LOADING ASSET"
            infoMessageColor = .green
            self.image = image
        }else{
            infoMessage = "ERROR GETTING ASSET"
            infoMessageColor = .pink
        }
    }
    
    func saveImage(){
        guard let image = image else {return}
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    
    func deleteImage(){
        guard let image = image else {return}
        infoMessage = manager.deleteImage(image: image, name: imageName)
    }
    
    
    func deleteFolder(){
        infoMessage = manager.deleteFolder()
    }
}
