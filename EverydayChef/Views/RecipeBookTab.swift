//
//  RecipeBookTab.swift
//  EverydayChef
//
//  Created by Alex Olechnowicz on 2023-05-26.
//

import SwiftUI

struct RecipeBookTab: View {
    
    @StateObject var fireDBController:FireDbController = FireDbController.sharedFireDBController
    
    var body: some View {
        if #available(iOS 16.0, *) {
            
            NavigationStack{
                
                ScrollView{
                    
                    GifImageView("chefcooktransparent")
                        .frame(width: 370, height: 300)
                    
                    
                    Grid(horizontalSpacing:20, verticalSpacing: 40){
                        GridRow{
                            NavigationLink {
                                RandomRecipeView()
                            } label: {
                                VStack{
                                    Image("randomrecipe")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 96, height: 96)
                                        .foregroundColor(.white)
                                        Text("Random Recipes")
                                            .lineLimit(2)
                                            .bold()
                                            .fixedSize()
                                    
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 170)
                                .background(Color("randomrecipebackground").opacity(0.8))
                                .cornerRadius(10)
                            }

                            
                            NavigationLink {
                                CreateRecipeView().environmentObject(fireDBController)
                            } label: {
                                VStack{
                                    Image("chefcooking")
                                    Text("Create Recipe")
                                        .lineLimit(2)
                                        .foregroundColor(.brown)
                                        .bold()
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 170)
                                .background(Color("createrecipebackground").opacity(0.8))
                                .cornerRadius(10)
                            }

                        }
                        
                        GridRow{
                            VStack{
                                Image("wineglass")
                                    .resizable()
                                    .frame(width: 96, height: 96)
                                Text("Wine Pairings")
                                    .foregroundColor(.red)
                                    .bold()
                                    .fixedSize()
                            }
                            .foregroundColor(.white)
                            .padding(25)
                            .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 170)
                            .background(Color("winepairingsbackground").opacity(0.8))
                            .cornerRadius(10)
                            
                            NavigationLink {
                                CustomRecipeListView().environmentObject(fireDBController)
                            } label: {
                                VStack{
                                    Image("wineglass")
                                        .resizable()
                                        .frame(width: 96, height: 96)
                                    Text("Custom Recipes")
                                        .foregroundColor(.red)
                                        .bold()
                                        .fixedSize()
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 170)
                                .background(Color("winepairingsbackground").opacity(0.8))
                                .cornerRadius(10)
                            }
                            
        //                    VStack{
        //                        Image(systemName: "message.fill")
        //                        Text("Random Recipes")
        //                    }
        //                    .foregroundColor(.white)
        //                    .padding(25)
        //                    .frame(minWidth: 0, maxWidth: 120, minHeight: 0, maxHeight: 120)
        //                    .background(.red)
                        }
                        
                    }
                    
                }//ScrollView
                
                
                
            }//NavigationStack
            
        }//if iOS 16
        else{
            GeometryReader{ space in
                ScrollView{
                    VStack(alignment: .center){
                        //gif
                        GifImageView("chefcooktransparent")
                            .frame(width: space.size.width, height: space.size.height/3)//.border(.black).fixedSize()
                        //row1
                        HStack{
                            NavigationLink {
                                RandomRecipeView()
                            } label: {
                                VStack{
                                    Image("randomrecipe")
                                        .renderingMode(.template)
                                        .resizable()
                                        //.frame(width: space.size.width/4,height: space.size.width/4)
                                        .foregroundColor(.white)
                                        Text("Random Recipes")
                                            .lineLimit(2)
                                            //.bold()
                                            .fixedSize()
                                    
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                //.frame(width: space.size.width/2.1,height: space.size.width/2.1)
                                .background(Color("randomrecipebackground").opacity(0.8))
                                .cornerRadius(10)
                            }
                            
                            NavigationLink {
                                CreateRecipeView().environmentObject(fireDBController)
                            } label: {
                                VStack{
                                    Image("chefcooking")
                                        //.renderingMode(.template)
                                        .resizable()
                                        //.frame(width: space.size.width/4,height: space.size.width/4)
                                        //.foregroundColor(.white)
                                    Text("Create Recipe")
                                        .lineLimit(2)
                                        .foregroundColor(.brown)
                                        //.bold()
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                //.frame(width: space.size.width/2.1,height: space.size.width/2.1)
                                .background(Color("createrecipebackground").opacity(0.8))
                                .cornerRadius(10)
                            }
                        }.frame(width: space.size.width, height: space.size.height/3)
                        //row2
                        HStack{
                            NavigationLink {
                                WinePairingsView()
                            } label: {
                                VStack{
                                    Image("wineglass")
                                        .resizable()
                                    //.frame(width: space.size.width/4,height: space.size.width/4)
                                    Text("Wine Pairings")
                                        .foregroundColor(.red)
                                        .bold()
                                        .fixedSize()
                                }
                                .foregroundColor(.white)
                                .padding(25)
                                //.frame(width: space.size.width/2.1,height: space.size.width/2.1)
                                .background(Color("winepairingsbackground").opacity(0.8))
                                .cornerRadius(10)
                            }
                            NavigationLink {
                                CustomRecipeListView().environmentObject(fireDBController)
                            } label: {
                                VStack{
                                    Image("wineglass")
                                        .resizable()
                                        //.frame(width: space.size.width/4,height: space.size.width/4)
                                    Text("Custom Recipes")
                                        .foregroundColor(.red)
                                        .bold()
                                        .fixedSize()
                                }
                                .foregroundColor(.white)
                                .padding(25)
//                                .frame(width: space.size.width/2.1,height: space.size.width/2.1)
                                .background(Color("winepairingsbackground").opacity(0.8))
                                .cornerRadius(10)
                            }
                        }.frame(width: space.size.width, height: space.size.height/3)
                    }//.border(.black)
                }.clipped()
            
            }
            
        }
    }
}

struct RecipeBookTab_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                RecipeBookTab().environmentObject(FireDbController.sharedFireDBController)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
