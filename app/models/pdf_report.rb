# frozen_string_literal: true	

# Prepare and render order samples report to pdf	
class PdfReport	
  def initialize(game)	
    @game = game
  end	

  def to_pdf	
    ApplicationController.render template: "/pdf/report"		
  end
end