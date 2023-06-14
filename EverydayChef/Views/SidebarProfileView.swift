//
//  SidebarProfileView.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-31.
//

import SwiftUI


struct SidebarProfileView: View {
    
    let sidebarWidth = UIScreen.main.bounds.size.width * 0.6
    let contentHight = UIScreen.main.bounds.size.height * 0.5
    
    @Binding var isSidebarVisable: Bool
    @Binding var sidebarHidden: Bool
    
    var body: some View {
        
            ZStack{
                GeometryReader{ _ in
                    //Text("")
                }
                .background(.black.opacity(0.3))
                .opacity(isSidebarVisable ? 1 : 0)
                .animation(.easeInOut, value: isSidebarVisable)
                .onTapGesture {
                    isSidebarVisable.toggle()
                    //delay for toolbar to reappear
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(0.3)){
                        self.sidebarHidden = false
                    }
                }
                
                HStack(alignment: .top, spacing: 0){
                    ZStack(alignment: .top){
                        GeometryReader{ _ in
                            
                            VStack(alignment: .center, spacing: 25){
                                VStack{
                                    Text("Users Name").font(.title2).foregroundColor(Color.black)
                                    //Text("Logged@In.Email").font(.subheadline).foregroundColor(Color.white)
                                }.padding(.bottom, 25).padding(.top, 25)
                                
                                Button(action:{
                                    
                                }){
                                    Text("Account")
                                }
                                .foregroundColor(Color.black)
                                .padding(10)
                                .border(.black)
                                .cornerRadius(2)
                                
                                Button(action:{
                                    
                                }){
                                    Text("Settings")
                                }
                                .foregroundColor(Color.black)
                                .padding(10)
                                .border(.black)
                                .cornerRadius(2)
                                Button(action:{
                                    
                                }){
                                    Text("Logout")
                                }
                                .foregroundColor(Color.black)
                                .padding(10)
                                .border(.black)
                                .cornerRadius(2)
                                Spacer()
                            }.padding(25).frame(width: sidebarWidth - 30, height: contentHight)
                                //.border(.black)
                                .padding(.leading, 15)
                           
                        }
                    }
                    .background(.cyan)
                    .opacity(isSidebarVisable ? 1 : 0)
                    .frame(width: sidebarWidth)
                    .offset(x: isSidebarVisable ? 0 : -sidebarWidth)
                    .animation(.default, value: isSidebarVisable)
                    //.edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
               
            }//.edgesIgnoringSafeArea(.all)
            
        
        
        
        
    }
}

//struct SidebarProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarProfileView()
//    }
//}
