class PagesController < ApplicationController
  def about; end

  def contact; end

  def report; end

  def rules; end

  def mobiles
    render layout: false
  end

  def season0; end
end
