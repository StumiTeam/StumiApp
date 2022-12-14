//
//  TimerView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 6/18/2022.
//

import SwiftUI
import Combine

struct TimerView: View {
    
    //USED TO SET TIME FOR TIMER
    @State private var offset = CGFloat.zero
    @State private var HoursOffset = CGFloat.zero
    @State private var MinutesOffset = CGFloat.zero
    @State private var SecondsOffset = CGFloat.zero
    @State private var Hours : Int = 0
    @State private var Minutes : Int = 0
    @State private var Seconds : Int = 0
    
    //USED TO COUNTDOWN TIMER
    @State var hoursRemaining = 1
    @State var minutesRemaining = 0
    @State var secondsRemaining = 1
    
    //STOPWATCH USED TO TRACK USER PROGRESS
    @State var secondsOngoing = 0
    @State var showTimer = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //USED TO PICK SUBJECTS
    @State var selectedSubject = "English"
    let subjects = ["English", "Math", "Social Studies", "Science"]
    
    //Detector for when user stops scrolling the time selector
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    var body: some View {
        //Button
        if showTimer == false{
//            Color.black
//                .ignoresSafeArea()
            
            VStack(alignment: .center){
                
                Spacer()
                //HStack {
                    VStack {
                        Text("Selected Subject:")
                        Menu(selectedSubject) {
                            
                            //English Choice
                            Button{
                                selectedSubject = "English"
                            } label: {Text("English")}
                            
                            //Math Choice
                            Button{
                                selectedSubject = "Math"
                            } label: {Text("Math")}
                            
                            //Social Studies Choice
                            Button{
                                selectedSubject = "Social Studies"
                            } label: {Text("Social Studies")}
                            
                            //Science Choice
                            Button{
                                selectedSubject = "Science"
                            } label: {Text("Science")}
                        }
                    }
                    .font(.headline)
                    .padding(10)
                    .background(.red)
                
                    /*
                    Button{
                        
                    } label: {Image("Cat")}
                     */
                //}
                
                Spacer()
                
                HStack(alignment: .top){
                    Spacer()
                    
                    //Hours HStack
                    HStack(alignment: .top){
                        //hours
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                ForEach(0..<12) { i in
                                    if(i<7){
                                        Text("\(i)")
                                            .font(.callout)
                                            .frame(alignment: .leading)
                                            .id(i)
                                            //every 40.0 new hour
                                            .padding(.bottom, 13)
                                            .padding(.horizontal, 5)
                                    }
                                    else {
                                        Text("\(i)")
                                            .font(.callout)
                                            .frame(alignment: .leading)
                                            .id(i)
                                            //every 40.0 new hour
                                            .padding(.bottom, 13)
                                            .padding(.horizontal, 5)
                                            .opacity(0)
                                    }
                                }
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                                .onPreferenceChange(ViewOffsetKey.self) {
                                    detector.send($0)
                                    HoursOffset = $0
                                    Hours = Int(ScrollViewNumber(Offset: HoursOffset))
                                    if(Hours>6){ Hours = 6}
                                    //print("Hours Offset >> \(HoursOffset)")
                                    //print("Hours \(Hours)")
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Hours, anchor: .top)
                                    }
                                    //print("publish")
                                })
                            
                            }
                        }
                            .coordinateSpace(name: "scroll")
                            .frame(height: 200)
                    
                        Text("Hours").font(.callout)
                    }
                    //.foregroundColor(.white)
                    Spacer()
                    
                    //Minutes HStack
                    HStack(alignment: .top){
                        //minutes
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                ForEach(0..<65) { i in
                                    if(i<60){
                                        Text("\(i)")
                                            .font(.callout)
                                            .frame(alignment: .leading)
                                            .id(i)
                                            //every 40.0 new minute
                                            .padding(.bottom, 13)
                                            .padding(.horizontal, 5)
                                    }
                                    else {
                                        Text("\(i)")
                                            .font(.callout)
                                            .frame(alignment: .leading)
                                            .id(i)
                                            //every 40.0 new minute
                                            .padding(.bottom, 13)
                                            .padding(.horizontal, 5)
                                            .opacity(0)
                                    }
                                }
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                                .onPreferenceChange(ViewOffsetKey.self) {
                                    detector.send($0)
                                    MinutesOffset = $0
                                    Minutes = Int(ScrollViewNumber(Offset: MinutesOffset))
                                    if(Minutes>59){ Minutes = 59}
                                    //print("Hours Offset >> \(HoursOffset)")
                                    //print("Hours \(Hours)")
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Minutes, anchor: .top)
                                    }
                                    //print("publish")
                                })
                            }
                        }
                            .coordinateSpace(name: "scroll")
                            .frame(minHeight: 100, maxHeight: 200)
                            
                        Text("Minutes").font(.callout)
                    }
                    //.foregroundColor(.white)
                    Spacer()
                    
                    //Seconds HStack
                    HStack(alignment: .top){
                        //seconds
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                //VStack {
                                    ForEach(0..<65) { i in
                                        if(i<60){
                                            Text("\(i)")
                                                .font(.callout)
                                                .frame(alignment: .leading)
                                                .id(i)
                                                //every 40.0 new second
                                                .padding(.bottom, 13)
                                                .padding(.horizontal, 5)
                                        }
                                        else {
                                            Text("\(i)")
                                                .font(.callout)
                                                .frame(alignment: .leading)
                                                .id(i)
                                                //every 40.0 new second
                                                .padding(.bottom, 13)
                                                .padding(.horizontal, 5)
                                                .opacity(0)
                                        }
                                    //}
                                }.background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                                .onPreferenceChange(ViewOffsetKey.self) {
                                    detector.send($0)
                                    SecondsOffset = $0
                                    Seconds = Int(ScrollViewNumber(Offset: SecondsOffset))
                                    if(Seconds>59){ Seconds = 59}
                                    //print("Seconds Offset >> \(SecondsOffset)")
                                    //print("Seconds: \(Seconds)")
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Seconds, anchor: .top)
                                    }
                                    //print("publish")
                                })
                            }
                        }
                            .coordinateSpace(name: "scroll")
                            .frame(minHeight: 100, maxHeight: 200)
                        Text("Seconds").font(.callout)
                    }
                    //.foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 360, minHeight: 0, maxHeight: 360, alignment: .top)
                .position(x:200, y:250)
                //.border(.green)
                
                Spacer()
                
                Button("Start", action: {
                    hoursRemaining = Hours
                    minutesRemaining = Minutes
                    secondsRemaining = Seconds
                    showTimer = true
                })
                    .font(.title)
                    .frame(width: 100.0, height: 100.0)
                    .foregroundColor(Color(red: 0, green: 128, blue: 0))
                    .background(.green)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .clipShape(Circle())
                    .padding(.bottom, 100)
                
                //Spacer()
                
                //insert library button here somewhere
                //keep track of what subject the user is studying
                
            }
            
        }
        
        //if showTimer == true
        if showTimer {
            
            VStack {
                Text("Seconds Ongoing: \(secondsOngoing)")
                
                if(minutesRemaining < 10 && secondsRemaining < 10){
                    Text("Time Left: 0\(hoursRemaining) : 0\(minutesRemaining) : 0\(secondsRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                else if(minutesRemaining<10){
                    Text("Time Left: 0\(hoursRemaining) : 0\(minutesRemaining) : \(secondsRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                else if(secondsRemaining<10){
                    Text("Time Left: 0\(hoursRemaining) : \(minutesRemaining) : 0\(secondsRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                else {
                    Text("Time Left: 0\(hoursRemaining) : \(minutesRemaining) : \(secondsRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                }
                
            }
            .onReceive(timer) {
                
                time in
                
                //hidden stopwatch
                if(hoursRemaining != 0 || minutesRemaining != 0 || secondsRemaining != 0){
                    secondsOngoing += 1
                }

                //countdown
                if secondsRemaining == 0 {
                    if minutesRemaining == 0 {
                        if hoursRemaining == 0 { //if there is no time left
                            
                            print("DONE! Time: \(secondsOngoing) seconds in \(selectedSubject)")
                            
                            //stop displaying timer
                            showTimer = false
                            
                            //reset the hidden stopwatch for next run
                            secondsOngoing = 0
                            
                            //record total time alongside start time and date
                            
                            
                            //give rewards (coins) on popup screen
                            
                            
                        } else { //if there are hours left
                            hoursRemaining -= 1
                            minutesRemaining = 59
                            secondsRemaining = 59
                        }
                        
                    } else { //if there are minutes left
                        minutesRemaining -= 1
                        secondsRemaining = 59
                    }
                    
                } else{ //if there are seconds left
                    secondsRemaining -= 1
                }
            }
        } //end showTimer
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

func ScrollViewNumber(Offset: CGFloat) -> CGFloat {
    @State var count : CGFloat
    count = round(Offset/40)
    
    return count
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
  }
}
