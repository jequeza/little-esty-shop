class UpcomingHoliday
  attr_reader :holiday, :holiday_date
  def initialize(data)
    @holiday = data[:name]
    @holiday_date = data[:date]
  end
end