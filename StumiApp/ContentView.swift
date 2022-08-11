/*
ContentView.swift
StumiApp

Created by Jeremy Kwok on 8/3/22.

Notes:
Modifiers such as .offset(x:100, y:200) must go under whatever they are modifying
 
Useful Modifiers
 Pictures:
    .resizable()   - Stretches the image to fit the safety area
 
    .scaledToFit() - Keeps the ratio the same but fits one side along one axis
    .aspectRatio(contentMode: .fit) - Does the same thing as scaledToFit()
 
    .scaledToFill() - Scales image to fit entire view but keeps ratio (image might go beyond bounds)
    .aspectRatio(contentMode: .fill) - Does the same thing as scaledToFill()
 
    .frame(width: _, height: _) - Sets a bounding frame for the object view
    .clipped() - Clips the image content that's beyond bounding frame
 
    .border(Color."color") - Sets a "color" border
 
 Text
    .font(."font") - sets the font
        By descending size: largeTitle, Title, Title2, Title3, subheadline, Body, Callout, Footnote, Caption, Caption2
 
    .foregroundColor(."color") - sets the color of the text
        Colors: Red, Orange, Yellow, Green, Mint, Teal, Cyan, Blue, Indigo, Purple, Pink, Brown, White, Gray, Black
        By descending transparency: Primary, secondary, clear
 */

import SwiftUI

enum Sheets: Identifiable {
    
    var id: Int {
        self.hashValue
    }
    
    case sheet0
    case sheet1
    case sheet2
}

struct ContentView: View {
    private var languages = ["English", "Korean", "Spanish"]
    @State private var selectedLanguage = "English"
    @State private var activeSheet: Sheets?
    var body: some View {
        VStack{
            /*
            Picker("Language", selection: $selectedLanguage, content:{
                ForEach(languages, id: \.self, content: { languages in
                    Text(languages)
                })
            })
            Text("Selected Language: \(selectedLanguage)")
             */
            VStack{
                Button("Settings") {
                    activeSheet = .sheet0
                }
                Button("FAQ"){
                    activeSheet = .sheet1
                }
                Button("Game"){
                    activeSheet = .sheet2
                }
            }
        
            .sheet(item:$activeSheet) { item in
            
                switch item {
                    case .sheet0:
                        Text("Settings")
                    case .sheet1:
                        Text("FAQ")
                    case .sheet2:
                        Text("Game")
                }
            }
            
            
            //Display
            Image("Cat")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 400)
                .clipped()
                //.padding()
            
            Text("Cat")
                //.offset(x:0, y:-400)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Kitten")
                .font(.title)
                .foregroundColor(.secondary)
        }
    }
}

struct MainView: View {
    var body: some View {
        Button(action: {
            print("Open the side menu")
        }) {
            Text("Show Menu")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .previewInterfaceOrientation(.portrait)
    }
}
