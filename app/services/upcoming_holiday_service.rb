class UpcomingHolidayService < ApiService
  def upcoming_holidays
    upcoming_holidays_endpoint = "https://date.nager.at/Api/v2/NextPublicHolidays/us"
    get_data(upcoming_holidays_endpoint)
  end
end