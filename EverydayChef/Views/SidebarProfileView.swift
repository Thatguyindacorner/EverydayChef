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
    
    @State var deleteAccountConfirmation: Bool = false
    
    @EnvironmentObject var session: SessionData
    @Environment(\.presentationMode) var presentationMode
    
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
                                
                                //if anonoumous account, signout and delete account (delete on backend)
                                //else, signout
                                Button(action:{
                                    
                                    if session.tempararyAccount{
                                        
                                        //trigger alert to confirm action
                                        self.deleteAccountConfirmation = true
                                    }
                                    else{
                                        signout()
                                    }
                                    
                                }){
                                    if session.tempararyAccount{
                                        Text("Delete Account")
                                        //trigger alert to confirm action
                                    }
                                    else{
                                        Text("Logout")
                                    }
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
            .alert(isPresented: $deleteAccountConfirmation){
                Alert(title: Text("Confirmation Required"),
                      message: Text("Are you sure you want to delete your temporary account?"),
                      primaryButton: .cancel(
                        Text("Cancel"),
                        action: {
                            print("canceled signout")
                        }),
                      secondaryButton: .destructive(
                        Text("Yes"),
                        action: {
                            signout()
                        })
                      )
            }
        
        
        
        
    }
    
    func signout(){
        Task{
            if await AuthController.signOut(){
                self.presentationMode.wrappedValue.dismiss()
            }
            else{
                print("error signing out")
            }
        }
    }
    
    
}

//struct SidebarProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarProfileView()
//    }
//}
