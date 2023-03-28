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
    @State private var time: String = ""
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Pomodoro timer").font(.title)
                .padding(.top, 40)
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
                    if (travail != 0 && pause != 0) {
                        time = String(travail)
                        DispatchQueue.main.async {
                            NSApp.keyWindow?.makeFirstResponder(nil)
                        }
                    }
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
                            if (Int(time) == 0 && status == false) {
                                time = String(pause)
                                status = true
                                sendNotification(title: "Pause", message: "Le travail est fini maintenant tu peux prendre une petite pause")
                            } else if (Int(time) == 0 && status == true) {
                                time = String(travail)
                                status = false
                                sendNotification(title: "Travail", message: "La pause est fini maintenant il faut travailler")
                            }
                            time = String((Int(time) ?? 0) - 1)
                        }
                    }
                    HStack {
                        Button(action: {
                            if(Int(time) ?? 0 > 0) {
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
                        if (time != "") {
                            Button(action: {
                                isTimerRunning = false
                                time = ""
                                travail = 0
                                pause = 0
                            }) {
                                Text("Reset")
                            }.padding(10).background(Color.red)
                        }
                    }
                    .padding(.bottom, 30)
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
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
