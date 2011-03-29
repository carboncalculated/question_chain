module TestApp
  def self.calculated_session
    @session ||= Calculated::Session.create(:api_key => ENV["CALCULATED_API_KEY"], )
  end
end