# Step Tracker
This Step Tracker intedgrates Apple Health to display your step counts and weight for the last 28days. These displays are on interactive charts and animated. You are also able to find the average per weekday for both steps and weight to see on which days of the week you do more/less steps or weight gain/loss.

# Technologies used
* SwiftUI
* HealthKit
* Swift Charts
* Swift Algorithms
* DocC
* Git & Github

# Animated Swift Charts
![video_alt](https://github.com/JeremyChew123/step-tracker/blob/3fa44a14c33b6735722a813dc3c0c5a640d6a671/Health%20App%20Mockup.mov)

# I'm most proud of...
Creating the average weight difference per day of the week. As I wanted to gain a bit of weight/bulk, I created a chart which determined which days do I see a significant increase in weight (e.g., On tuesdays the average weight gain 0.7kg)

I pulled the last 29 days and did a calculation on the differences of each day. I then averaged it to each weekday's gain/loss and displayed them on a bar chart and conditionally coloured them to represent a gain or a loss in weight.

```swift
static func averageDailyWeightDiffs(for metric: [HealthMetric]) -> [DateValueChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        guard metric.count > 1 else { return []}
        
        for i in 1..<metric.count {
            let date = metric[i].date
            let value = metric[i].value - metric[i-1].value
            diffValues.append((date: date, value: value))
            print(diffValues)
        }
        print(diffValues)
        let sortByWeekday = diffValues.sorted(using: KeyPathComparator(\.date.weekdayInt))
        let weekdayArray = sortByWeekday.chunked {$0.date.weekdayInt == $1.date.weekdayInt}
        
        var weeklyChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let averageWeight = total / Double(array.count)
            
            weeklyChartData.append(.init(date: firstValue.date, value: averageWeight))
        }
        
        return weeklyChartData
    }
}
```
![image_alt](https://github.com/JeremyChew123/step-tracker/blob/3fa44a14c33b6735722a813dc3c0c5a640d6a671/Weight%20Tracker%20Mockup.png)

# Completness
* Error Handling
* Empty States
* Permission Priming
* Text Input Validation
* Basic Unit Tests
* Basic Accessibility
* Privacy Manifest
* Code Documentation (DooC)
* Project Organisation


