//
//  ViewController.swift
//  DTCalendarView
//
//  Created by timle8n1-dynamit on 06/14/2017.
//  Copyright (c) 2017 timle8n1-dynamit. All rights reserved.
//

import UIKit
import DTCalendarView

class ViewController: UIViewController {
    
    fileprivate let now = Date()
    
    fileprivate let calendar = Calendar.current
    
    @IBOutlet private var calendarView: DTCalendarView! {
        didSet {
            calendarView.delegate = self
            
            calendarView.displayEndDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 2)
            calendarView.previewDaysInPreviousAndMonth = true
            calendarView.paginateMonths = true
        }
    }
    
    fileprivate let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        
        formatter.dateFormat = "MMMM YYYY"
        
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func currentDate(matchesMonthAndYearOf date: Date) -> Bool {
        let nowMonth = calendar.component(.month, from: now)
        let nowYear = calendar.component(.year, from: now)
        
        let askMonth = calendar.component(.month, from: date)
        let askYear = calendar.component(.year, from: date)
        
        if nowMonth == askMonth && nowYear == askYear {
            return true
        }
        
        return false
    }
}

extension ViewController: DTCalendarViewDelegate {
    
    func calendarView(_ calendarView: DTCalendarView, dragFromDate fromDate: Date, toDate: Date) {
        
        if let nowDayOfYear = calendar.ordinality(of: .day, in: .year, for: now),
            let selectDayOfYear = calendar.ordinality(of :.day, in: .year, for: toDate),
            selectDayOfYear <= nowDayOfYear {
            return
        }
        
        if let startDate = calendarView.selectionStartDate,
            fromDate == startDate {
            
            if let endDate = calendarView.selectionEndDate {
                if toDate < endDate {
                    calendarView.selectionStartDate = toDate
                }
            } else {
                calendarView.selectionStartDate = toDate
            }
            
        } else if let endDate = calendarView.selectionEndDate,
            fromDate == endDate {
            
            if let startDate = calendarView.selectionStartDate {
                if toDate > startDate {
                    calendarView.selectionEndDate = toDate
                }
            } else {
                calendarView.selectionEndDate = toDate
            }
        }
    }
    
    func calendarView(_ calendarView: DTCalendarView, viewForMonth month: Date) -> UIView {
        
        let label = UILabel()
        label.text = monthYearFormatter.string(from: month)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        
        return label
    }
    
    func calendarView(_ calendarView: DTCalendarView, disabledDaysInMonth month: Date) -> [Int]? {
        
        if currentDate(matchesMonthAndYearOf: month) {
            var disabledDays = [Int]()
            
            let nowDay = calendar.component(.day, from: now)
            
            for day in 1 ... nowDay {
                disabledDays.append(day)
            }
                
            return disabledDays
        }
        
        return nil
    }
    
    func calendarView(_ calendarView: DTCalendarView, didSelectDate date: Date) {
        
        if let nowDayOfYear = calendar.ordinality(of: .day, in: .year, for: now),
            let selectDayOfYear = calendar.ordinality(of :.day, in: .year, for: date),
            selectDayOfYear <= nowDayOfYear {
            return
        }
        
        if calendarView.selectionStartDate == nil {
            calendarView.selectionStartDate = date
        } else if calendarView.selectionEndDate == nil {
            if let startDateValue = calendarView.selectionStartDate {
                if date <= startDateValue {
                    calendarView.selectionStartDate = date
                } else {
                    calendarView.selectionEndDate = date
                }
            }
            
        } else {
            calendarView.selectionStartDate = date
            calendarView.selectionEndDate = nil
        }
    }
    
    func calendarViewHeightForWeekRows(_ calendarView: DTCalendarView) -> CGFloat {
        return 60
    }
    
    func calendarViewHeightForWeekdayLabelRow(_ calendarView: DTCalendarView) -> CGFloat {
        return 50
    }
    
    func calendarViewHeightForMonthView(_ calendarView: DTCalendarView) -> CGFloat {
        return 60
    }
}

