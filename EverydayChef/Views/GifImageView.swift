//
//  GifImageView.swift
//  CatchEmAllApp
//
//  Created by Ameya Joshi on 2023-06-14.
//

import SwiftUI
import WebKit

struct GifImageView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    var imageName:String
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let webView = WKWebView()
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "gif") else{
            return WKWebView()
        }
        
        
        let data = try! Data(contentsOf: url)
        
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
    
    
}

struct GifImageView_Previews: PreviewProvider {
    static var previews: some View {
        GifImageView("foodimgtransparent2")
    }
}
