// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class EpisodesPresenter {
    
    private let calendar: Calendar
    private let locale: Locale
    
    public init(calendar: Calendar = .current, locale: Locale = .current) {
        self.calendar = calendar
        self.locale = locale
    }
    
    private lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        return formatter
    }()
    
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = newCalendar
        return formatter
    }()
    
    public func map(_ model: Episode, currentDate: Date = Date()) -> EpisodeViewModel {
        let presentablePublishDate = mapToPresentablePublishDate(
            publishDateInMiliseconds: model.publishDateInMiliseconds,
            relativeTo: currentDate
        )
        return EpisodeViewModel(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: mapToPresentableAudioLength(model.audioLengthInSeconds),
            displayPublishDate: presentablePublishDate
        )
    }
    
    private func mapToPresentableAudioLength(_ lengthInSeconds: Int) -> String {
        dateFormatter.string(from: TimeInterval(lengthInSeconds)) ?? "INVALID_DURATION"
    }
    
    private func mapToPresentablePublishDate(publishDateInMiliseconds: Int, relativeTo currentDate: Date) -> String {
        let publishDateInSeconds = publishDateInMiliseconds / 1000
        let presentablePublishDate = Date(timeIntervalSince1970: TimeInterval(publishDateInSeconds))
        return relativeDateTimeFormatter.localizedString(for: presentablePublishDate, relativeTo: currentDate)
    }
}
