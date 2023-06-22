//
//  WinePairingsView.swift
//  EverydayChef
//
//  Created by Ameya Joshi on 2023-06-19.
//

import SwiftUI

struct WinePairingsView: View {
    
    @State private var pickerSelection:Int = 0
    
    @State private var wineTypes:[String] = ["Merlot", "Malbec", "Pinot Noir"]
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            
            ScrollView{
                
                VStack {
                    Image("wine")
                        .resizable()
                        .scaledToFill()
//                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.28)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.23)
                    VStack{
                        Text("Select Wine Types")
                        Picker("Select Wine Type", selection: self.$pickerSelection, content: {
                            ForEach(0..<self.wineTypes.count){ index in
                                Text(String(self.wineTypes[index]))
                            }
                        })
                        .padding(.bottom, 10)
                        .pickerStyle(SegmentedPickerStyle())
                        
                        
                        
                    }//VStack
                    .padding()
                }
                
                //.navigationTitle(Text("Wine Pairings"))
            }//ScrollView
            .ignoresSafeArea(.all)
        }//if IOS 16 and UP
    }
}

struct WinePairingsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                WinePairingsView()
            }
        }
    }
}
