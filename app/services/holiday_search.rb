class HolidaySearch

  def service
    NagerService.next_us_holidays
  end

  def next_three_us_holidays
    service.map do |holiday|
      Holiday.new(holiday)
    end.first(3)
  end
end