//
//  ContentView.swift
//  chrono
//
//  Created by Thomas Da Silva on 26/03/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var travail: Int = 0
    @State private var pause: Int = 0
    @State private var startTime = Date()
    @State private var didTap:Bool = false
    @State var isTimerRunning:Bool = false
    @State var status:Bool = false
    @State private var time: Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Pomodoro timer").font(.title)
                .padding(.top, 40)
            Text("Choissisez votre timer de travail et de pause").padding(10)
            Form {
                HStack {
                    TextField("Travail", value: $travail, formatter: NumberFormatter())
                    Stepper(value: $travail, in: 0...60) {
                        EmptyView()
                    }
                }
                HStack {
                    TextField("pause", value: $pause, formatter: NumberFormatter())
                    Stepper(value: $pause, in: 0...60) {
                        EmptyView()
                    }
                }
                Button("Ajouter ce temps") {
                    time = travail
                }
                
            }
            
            .padding(.horizontal, 80.0)
            .padding(.top, 50.0)
            .padding(.bottom, 40.0)
            HStack {
                VStack {
                    
                    Text("\(time)").onReceive(timer) {
                        _ in
                        if self.isTimerRunning {
                            if (time == 0 && status == false) {
                                time = pause
                                status = true
                                sendNotification(title: "Pause", message: "Le travail est fini maintenant tu peux prendre une petite pause")
                            } else if (time == 0 && status == true) {
                                time = travail
                                status = false
                                sendNotification(title: "Travail", message: "La pause est fini maintenant il faut travailler")
                            }
                            time -= 1
                        }
                    }
                    HStack {
                        Button(action: {
                            if(time > 0) {
                                isTimerRunning = true
                            }
                        }) {
                            Text("Start")
                        }.padding(10)
                            .background(didTap ? Color.blue : Color.yellow)
                        if(isTimerRunning) {
                            Button(action: {
                                isTimerRunning = false
                            }) {
                                Text("Stop")
                            }.padding(10).background(Color.red)
                        }
                    }
                }
            }
            
        }
        .padding()
    }
    
    func sendNotification(title: String, message: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = message
        notificationContent.sound = .default
        notificationContent.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
        // you could also use...
        // UNCalendarNotificationTrigger(dateMatching: .init(year: 2022, month: 12, day: 10, hour: 0, minute: 0), repeats: true)
        
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
