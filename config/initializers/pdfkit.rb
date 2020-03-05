def heroku?	
  ENV.fetch("ON_HEROKU", "no") == "yes"	
end	

def pdfkit_heroku_conf	
  PDFKit.configure do |config|	
    config.wkhtmltopdf = Gem.bin_path("wkhtmltopdf-heroku", "wkhtmltopdf-linux-amd64")	
    config.default_options = {	
      :page_size => 'A4',	
      :print_media_type => true	
    }	
  end	
end	

def pdfkit_local_conf	
  PDFKit.configure do |config|	
    config.wkhtmltopdf = Gem.bin_path("wkhtmltopdf-binary-edge", "wkhtmltopdf")	
    config.default_options = {	
      :page_size => 'A4',	
      :print_media_type => true	
    }	
  end	
end	

case Rails.env	
when "production", "test"	
  if heroku?	
    pdfkit_heroku_conf	
  else	
    pdfkit_local_conf	
  end	
when "development"	
  pdfkit_local_conf	
else	
  pdfkit_local_conf	
end