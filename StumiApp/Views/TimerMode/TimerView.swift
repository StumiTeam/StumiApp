//
//  TimerView.swift
//  Stumi App
//
//  Created by Jeremy Kwok on 6/18/2022.
//

import SwiftUI
import Combine

struct TimerView: View {
    
    //View Models
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    //New instance of TimerViewModel
    @StateObject var timerViewModel = TimerViewModel()
    
    //Move to TimerView - ViewModel
     
    //USED TO SET TIME FOR TIMER
    @State private var offset = CGFloat.zero
    @State private var HoursOffset = CGFloat.zero
    @State private var MinutesOffset = CGFloat.zero
    @State private var SecondsOffset = CGFloat.zero
    
    @State private var Hours : Int = 0
    @State private var Minutes : Int = 0
    @State private var Seconds : Int = 0
    
    //USED TO COUNTDOWN TIMER
    @State var hoursRemaining = 0
    @State var minutesRemaining = 0
    @State var secondsRemaining = 0
    
    //STOPWATCH USED TO TRACK USER PROGRESS
    @State var secondsOngoing = 0
    @State var showTimer = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //USED TO RECORD STUDY SESSION
    let dateFormatter = DateFormatter()
    @State var timeNow = Date()
    @State var dateTime : String = ""
    
    //USED TO PICK SUBJECTS
    @State var subjects : [String] = []
    @State var selectedSubject : String = ""
    
    //USED TO DETERMINE REWARDS
    @State var baseGainedCoins = 0 //base number of coins user gained from their session
    @State var baseGainedBooks = 0 //base number of books animals gained from session
    @State var coinRate = 1 //1 coin per minute
    @State var bookRate = 1 //1 book per minute
    
    
    //Detector for when user stops scrolling the time selector
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    //Initialization
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
        dateFormatter.dateFormat = "MM-dd-yyyy, a hh:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    var body: some View {
        
        
        
        //Button
        if showTimer == false{
            
            VStack(alignment: .center){
                
                Spacer()
                
                subjectSelectionView(subjects: $userViewModel.mainPlayer.subjects, selectedSubject: userViewModel.mainPlayer.subjects[0])
                    .environmentObject(timerViewModel)
                
                Spacer()
                
                //Time Selection
                HStack(alignment: .top){
                    Spacer()
                    
                    //Hours HStack
                    HStack(alignment: .top){
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                ForEach(0..<12) { i in
                                    if(i<7){
                                        Text("\(i)")
                                            .id(i)
                                            .modifier(TimerNumber())
                                    }
                                    else {
                                        Text("\(i)")
                                            .id(i)
                                            .modifier(TimerNumber())
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
                                    Hours = Int(timerViewModel.getScrollViewNumber(Offset: HoursOffset))
                                    if( Hours > 6 ){ Hours = 6 }
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Hours, anchor: .top)
                                    }
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
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                ForEach(0..<65) { i in
                                    if(i<60){
                                        Text("\(i)")
                                            .id(i)
                                            .modifier(TimerNumber())
                                    }
                                    else {
                                        Text("\(i)")
                                            .id(i)
                                            .modifier(TimerNumber())
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
                                    Minutes = Int(timerViewModel.getScrollViewNumber(Offset: MinutesOffset))
                                    if(Minutes>59){ Minutes = 59}
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Minutes, anchor: .top)
                                    }
                                })
                            }
                        }
                            .coordinateSpace(name: "scroll")
                            .frame(minHeight: 100, maxHeight: 200)
                            
                        Text("Minutes")
                            .font(.callout)
                    }
                    //.foregroundColor(.white)
                    Spacer()
                    
                    //Seconds HStack
                    HStack(alignment: .top){
                        ScrollViewReader { proxy in
                            ScrollView (.vertical, showsIndicators: false){
                                    ForEach(0..<65) { i in
                                        if(i<60){
                                            Text("\(i)")
                                                .id(i)
                                                .modifier(TimerNumber())
                                        }
                                        else {
                                            Text("\(i)")
                                                .id(i)
                                                .modifier(TimerNumber())
                                                .opacity(0)
                                        }
                                }.background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                                .onPreferenceChange(ViewOffsetKey.self) {
                                    detector.send($0)
                                    SecondsOffset = $0
                                    Seconds = Int(timerViewModel.getScrollViewNumber(Offset: SecondsOffset))
                                    if(Seconds>59){ Seconds = 59}
                                }
                                .onReceive(publisher, perform: { _ in
                                    withAnimation{
                                        proxy.scrollTo(Seconds, anchor: .top)
                                    }
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
                
                Spacer()
                
                Button("Start", action: {
                    //initialize timer
                    timeNow = Date()
                    dateTime = dateFormatter.string(from: timeNow)
                    //print(dateTime)
                    
                    selectedSubject = timerViewModel.selectedSubject
                    hoursRemaining = Hours
                    minutesRemaining = Minutes
                    secondsRemaining = Seconds
                    contentViewModel.showButton = false
                    showTimer = true
                })
                    .font(.title)
                    .frame(width: 100.0, height: 100.0)
                    .foregroundColor(Color(red: 0/255, green: 128/255, blue: 0/255))
                    .background(.green)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .clipShape(Circle())
                    .padding(.bottom, 100)
                
                //Spacer()
                
                //insert library button here somewhere
                //keep track of what subject the user is studying
                
            }
        }
        if showTimer {
            
            VStack {
                Text("Seconds Ongoing: \(secondsOngoing)")
                
                HStack{
                    
                    Text("Time Left: 0\(hoursRemaining) : ")
                    
                    if(minutesRemaining < 10) {
                        Text("0\(minutesRemaining) : ")
                    } else {
                        Text("\(minutesRemaining) : ")
                    }
                    
                    if(secondsRemaining < 10) {
                        Text("0\(secondsRemaining)")
                    } else {
                        Text("\(secondsRemaining)")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(.black.opacity(0.75))
                .clipShape(Capsule())
            }
            
            .onReceive(timer) {

                time in

                //countdown
                if secondsRemaining == 0 {
                    if minutesRemaining == 0 {
                        if hoursRemaining == 0 { //if there is no time left
                            
                            print("New Study Session Recorded: \(secondsOngoing) seconds in \(selectedSubject)")
                            
                            //record studyDate: start time with subject and study duration
                            userViewModel.updateStudyHistory(dateTime: dateTime, subject: selectedSubject, timeStudied: secondsOngoing)
                            
                            //increment total time through userViewModel
                            userViewModel.incrementUserData(
                                propertyName: "totalTime",
                                incrementValue: secondsOngoing
                            )
                            
                            //calculate base rewards
                            baseGainedCoins = secondsOngoing/60
                            baseGainedBooks = secondsOngoing/60
                            
                            
                            //give rewards (coins) on popup screen
                            userViewModel.incrementUserData(
                                propertyName: "numCoins",
                                incrementValue: baseGainedCoins
                            )
                            
                            //sync after updating all items in Firestore
                            userViewModel.syncUser()
                            //userViewModel.createAnimal(animalName: "pp")
                            
                            //reset variables
                            secondsOngoing = 0 //reset stopwatch for next run
                            baseGainedCoins = 0 //reset gainedCoins
                            baseGainedBooks = 0 //reset gainedBooks
                            
                            //stop displaying timer
                            showTimer = false
                            contentViewModel.showButton = true
                            
                        } else { //if there are hours left
                            hoursRemaining -= 1
                            minutesRemaining = 59
                            secondsRemaining = 59
                        }
                    } else { //if there are minutes left
                        minutesRemaining -= 1
                        secondsRemaining = 59
                    }
                } else { //if there are seconds left
                    secondsRemaining -= 1
                    secondsOngoing += 1
                }
            }
            
            /*
            while hoursRemaining > 0 {
                while minutesRemaining > 0 {
                    while secondsRemaining > 0 {
                        secondsRemaining -= 1
                    }
                    minutesRemaining -= 1
                    secondsRemaining = 59
                }
                hoursRemaining -= 1
                minutesRemaining = 59
                secondsRemaining = 59
            }
            */
            
            //after all the while loops are over
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

struct TimerNumber: ViewModifier {
    func body(content: Content) ->  some View {
        content
            .font(.callout)
            .frame(alignment: .leading)
            //every 40.0 new number
            .padding(.bottom, 13)
            .padding(.horizontal, 5)
    }
}

struct subjectSelectionView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @Binding var subjects: [String]
    @State var selectedSubject: String
    
    var body: some View {
        Text("Selected Subject:")
        
        Menu(selectedSubject) {
            //Loop through subject list
            ForEach(0..<subjects.count, id: \.self ) { number in
                
                Button{
                    selectedSubject = subjects[number]
                    timerViewModel.selectedSubject = selectedSubject
                    print("Subjects:\(subjects)")
                } label: {
                    Text("\(subjects[number])")
                }
            }
        }
        .font(.headline)
        .padding(10)
        .foregroundColor(.white)
        .background(.red)
        .onAppear{timerViewModel.selectedSubject = selectedSubject}
    }
}

struct countdown {
    
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView()
          .environmentObject(UserViewModel())
  }
}
