//
//  CustomTableViewCell.swift
//  EST_Trip
//
//  Created by 정소이 on 6/13/25.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!

    @IBOutlet weak var dDayBackground: UIView!
    @IBOutlet weak var dDay: UILabel!

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        dDayBackground.layer.cornerRadius = 8
        dDayBackground.clipsToBounds = true
        
        tripImage.image = UIImage(systemName: "airplane")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        cellBackground.backgroundColor = selected ? .jejuOcean : .jejuOcean.withAlphaComponent(0.7)
    }
    
    func bind(travel: TravelEntity) {
        showDday(travel)

        tripTitle.text = travel.title // 📌 Schedule 메인에서 일정 제목 가져와 넣어주기
        tripDate.text = "\((travel.startDate ?? Date()).toString()) ~ \((travel.endDate ?? Date()).toString(format: "MM.dd"))" // 📌 Schedule 메인에서 날짜 가져와 넣어주기
    }
    
    private func showDday(_ travel: TravelEntity) {
        let targetDate = travel.startDate // 📌 Schedule 메인에서 날짜 가져와 넣어주기
        let today = Date.today

        let dayDiff = targetDate?.days(from: today) ?? 0

        if dayDiff == 0 {
            dDay.text = "D-Day"
        } else if dayDiff > 0 {
            dDay.text = "D-\(dayDiff)"
        } else {
            dDay.text = "D+\(abs(dayDiff))"
        }
    }
}

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        self = calendar.date(from: components) ?? .now  // 실패 시 현재 시각 반환
    }

    func days(from date: Date) -> Int {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: date) // 기준 날짜의 0시 0분
        let to = calendar.startOfDay(for: self)   // 현재 객체의 0시 0분
        return calendar.dateComponents([.day], from: from, to: to).day ?? 0
    }

    static var today: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: .now)
    }

    func toString(format: String = "yyyy.MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func monthDaytoString(format: String = "MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeToString(suffix: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H시 m분"
        let timeString = formatter.string(from: self)
        
        if let suffix = suffix {
            return "\(timeString) \(suffix)"
        } else {
            return timeString
        }
    }
}
