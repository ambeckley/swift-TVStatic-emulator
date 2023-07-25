//
//  ContentView.swift
//  tvStatic App
//
//  Created by Aaron Beckley on 7/24/23.
//

import SwiftUI


public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
    
   
    
}

struct ContentView: View {
    
    
    @State var image: UIImage = UIImage(named: "screenie")!
    @State var finished: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var uiImageArray: Array<UIImage> = []
    @State var height = 1000
    @State var width = 500
    @State var counter = 0
    
    func makeImage() {

        Task {
            var pixels: [PixelData] = .init(repeating: .init(a: 0, r: 0, g: 0, b: 0), count: width * height)
            
            pixels.indices.forEach {
                pixels[$0].a = 255
                pixels[$0].r = .random(in: 0...255)
                pixels[$0].g = .random(in: 0...255)
                pixels[$0].b = .random(in: 0...255)
                
            }
            uiImageArray.append(UIImage(pixels: pixels, width: width, height: height)!)
        }
    }
    
    
    
    var body: some View {
        
        
        ZStack {
            if finished {
                Image(uiImage: image)
                    .resizable()
                    //.imageScale(.large)
                    //.foregroundColor(.accentColor)
                    .onReceive(timer) { _ in
                        
                        image = uiImageArray[counter]
                        counter+=1
                        if counter == uiImageArray.count {
                            counter = 0
                        }
                        //image = uiImageArray.randomElement()!
                            
                        
                        
                    }
            } else {
                Text("Loading..")
            }
        }.edgesIgnoringSafeArea(.all).onAppear {
                    //https://stackoverflow.com/questions/7241936/how-do-i-detect-a-dual-core-cpu-on-ios
                    let processInfo = ProcessInfo()
                    //print(processInfo.activeProcessorCount)
                    var count = 0
                    
                    while count < 8 {
                        makeImage()
                        count+=1
                    }
       

                    var pixels: [PixelData] = .init(repeating: .init(a: 0, r: 0, g: 0, b: 0), count: width * height)
                    
                    for index in pixels.indices {
                        pixels[index].a = 255
                        pixels[index].r = .random(in: 0...255)
                        pixels[index].g = .random(in: 0...255)
                        pixels[index].b = .random(in: 0...255)
                        
                    }
                    uiImageArray.append(UIImage(pixels: pixels, width: width, height: height)!)
            
                    image = uiImageArray.randomElement()!
                    finished = true
                }
            
             
       
           
            
    }
        
    
}

//https://stackoverflow.com/questions/30958427/pixel-array-to-uiimage-in-swift
extension UIImage {
    convenience init?(pixels: [PixelData], width: Int, height: Int) {
        guard width > 0 && height > 0, pixels.count == width * height else { return nil }
        var data = pixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<PixelData>.size) as CFData)
            else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent)
        else { return nil }
        self.init(cgImage: cgim)
    }
}
