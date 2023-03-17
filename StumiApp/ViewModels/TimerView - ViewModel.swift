//
//  TimerView - ViewModel.swift
//  StumiApp
//
//  Created by Jeremy Kwok on 3/16/23.
//

import Foundation

extension TimerView {
    @MainActor class ViewModel: ObservableObject {
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
        @Published var selectedSubject = "English"
        let subjects = ["English", "Math", "Social Studies", "Science"]
        
        //USED TO DETERMINE REWARDS
        @Published var baseGainedCoins = 0 //base number of coins user gained from their session
        @Published var baseGainedBooks = 0 //base number of books animals gained from session
        @Published var coinRate = 1 //1 coin per minute
        @Published var bookRate = 1 //1 book per minute
    }
}
