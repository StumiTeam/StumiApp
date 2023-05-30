//
//  LibraryMenuView.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 8/28/22.
//

import SwiftUI

struct MenuView: View {
    
    //ViewModels
    @EnvironmentObject var contentViewModel: ContentViewModel
     
    //Variables
    let pageNames = [
        ["Timer", "systemName: 'gear'"],                      //0
        ["Achievements", "systemName: 'gear'"], //1
        ["Friends", "systemName: 'gear'"],      //2
        ["Library", "systemName: 'gear'"],      //3
        ["Search", "systemName: 'gear'"],       //4
        ["Store", "systemName: 'gear'"],        //5
        ["Profile", "systemName: 'gear'"],      //6
        ["Settings", "systemName: 'gear'"]      //7
    ]
    
    //body
    var body: some View {
        VStack(alignment: .leading) {
            
            //Top Page Icons
            ForEach((0...5), id: \.self){ index in
                Button(action: {
                    contentViewModel.showMenu = false;
                    contentViewModel.showPage = index;
                    print("Now changing to page: \(contentViewModel.showPage)")
                    print(index)
                }){
                    HStack {
                        Image(pageNames[index][1])
                        Text(pageNames[index][0])
                    }
                    .modifier(pageChoiceModifier())
                    .padding(.top, (index == 0) ? 120 : 30)
                }
            }// End Top Page Icons
            
            Spacer()
            
            //Bottom Page Icons
            ForEach((6...7), id: \.self){ index in
                Button(action: {
                    contentViewModel.showMenu = false;
                    contentViewModel.showPage = index;
                    print("Now changing to page: \(contentViewModel.showPage)")
                    print(index)
                }){
                    HStack {
                        Image(pageNames[index][1])
                        Text(pageNames[index][0])
                    }
                    .modifier(pageChoiceModifier())
                    .padding(.bottom, 30)
                }
            }// End Bottom Page Icons
            
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 20/255, green: 20/255, blue: 20/255))
            .edgesIgnoringSafeArea(.all)
    }
}

struct pageChoiceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray)
            .imageScale(.large)
            .font(.headline)
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
