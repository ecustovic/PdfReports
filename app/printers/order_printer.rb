# frozen_string_literal: true

# Prepare and render order report to pdf
class OrderPrinter < ApplicationPrinter

  def report(game)
    @game = game

    ApplicationController.render template: "/printers/order/report"
  end

  def filename
    "public/pdf/order_" + @game.id.to_s + ".pdf"
  end
end