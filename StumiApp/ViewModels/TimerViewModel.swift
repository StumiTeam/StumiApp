//
//  TimerViewModel.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class TimerViewModel: ObservableObject {
    
    @Published var selectedSubject: String
    
    init(){
        selectedSubject = ""
    }
    
    /*
    func recordStudyTime(subject: String, ) {
    }
    */
    
    func getScrollViewNumber(Offset: CGFloat) -> CGFloat {
        var count : CGFloat
        count = round(Offset/40)
        
        return count
    }
    
    func calculateCoinsReward(timeStudied: Float, baseCoinRate: Float, rateBoosters: [String] ) -> Float {
        let coinsReward = timeStudied * baseCoinRate
        return coinsReward
    }
    
    func calculateBooksReward(timeStudied: Float, baseBookRate: Float, rateBoosters: [String] ) -> Float {
        
        //let boosterValue = 1 +
        
        /*
        1. Look through array of current boosts
          boostName : boostValue, timesActive (0 means inactive)
          adBoost : 1.0, 1 -> For the next session, adBoost increases rewards by 100%
        2. Add up all active boost values
        3. Subtract 1 from all boosters that have timesActive bigger than 0
        4. Multiply base
        */
        
        //let boostedBookRate = baseBookRate * boosterValue
        
        let booksReward = timeStudied * baseBookRate
        return booksReward
    }
}

/*
 extension TimerView {
 @MainActor class TimerViewModel: ObservableObject {
 
 //USED TO SET TIME FOR TIMER
 @Published var offset = CGFloat.zero
 @Published var HoursOffset = CGFloat.zero
 @Published var MinutesOffset = CGFloat.zero
 @Published var SecondsOffset = CGFloat.zero
 
 @Published var Hours : Int = 0
 @Published var Minutes : Int = 0
 @Published var Seconds : Int = 0
 
 //USED TO COUNTDOWN TIMER
 @Published var hoursRemaining = 0
 @Published var minutesRemaining = 0
 @Published var secondsRemaining = 0
 
 //STOPWATCH USED TO TRACK USER PROGRESS
 @Published var secondsOngoing = 0
 @Published var showTimer = false
 let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
 //USED TO PICK SUBJECTS
 var selectedSubject : String
 var subjects : [String] = ["English", "Math", "Social Studies", "Science"]
 
 //USED TO DETERMINE REWARDS
 @Published var baseGainedCoins = 0 //base number of coins user gained from their session
 @Published var baseGainedBooks = 0 //base number of books animals gained from session
 @Published var coinRate = 1 //1 coin per minute
 @Published var bookRate = 1 //1 book per minute
 }
 }
 */
