require "liquid"
require "psych"
require "optparse"

CMD = "invoice"
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{CMD} [options]"

  opts.on(:REQUIRED, "-c", "--client [FILENAME]", String, "Client file") do |client|
    options[:client] = client
  end

  opts.on("-m", "--company [FILENAME]", String, "Company file") do |company|
    options[:company] = company
  end

  opts.on(:REQUIRED, "-w", "--work [FILENAME]", String, "Work file") do |work|
    options[:work] = work
  end

  opts.on(:REQUIRED, "-t", "--template [TEMPLATE]", String, "Template") do |template|
    options[:template] = template
  end
end.parse!

def get_file(file)
  if File.exists? file.to_s
    File.read file.to_s
  else
    nil
  end
end

paths = {
  :details   => (options[:company] or 'details.yaml'),
  :template  => (options[:template] or 'template.liquid'),
}

template = File.read(paths[:template])
data = Psych.load(File.read(paths[:details]))

if details = get_file(options[:client])
  data["client"] ||= Psych.load(details)
else
  exit
end

if work = get_file(options[:work])
  #puts Psych.load(File.read(paths[:work]))["work"]
  content = Psych.load(work)
  data["work"] = content["work"] if content["work"]
  data["description"] = content["description"] if content["description"]
  data["invoice"] = content["invoice"] if content["invoice"]
  data["keywords"] = content["keywords"] if content["keywords"]
  data["note"] = content["note"] if content["note"]
  data["terms"] = content["terms"] if content["terms"]
else
  puts "exiting"
  exit
end

def format_price(value)
  ('%.2f' % value).sub(',', '_').sub('.', ',').sub('_', '.') # dutch
end

total_discount = (data["work"].map { |w| (w["discount"] or 0) }.reduce :+ if data["work"]) or false
total_work = (data["work"].map { |w| w["value"] - (w["discount"] or 0) }.reduce :+ if data["work"]) or false
total_vat = 0
if data["invoice"] and data["invoice"]["vat_rate"].is_a?(Numeric)
  data["invoice"]["vat"] = true
  vat_rate = (data["invoice"]["vat_rate"] if data["invoice"]) or 21
  total_vat = (data["work"].map { |w| (w["value"] - (w["discount"] or 0))/100.0*(w["vat_rate"] or vat_rate) }.reduce :+ if data["work"]) or false
else
  data["invoice"]["vat"] = false
end

if data["invoice"]
  data["invoice"]["subtotal"] = ((format_price(total_work) if total_work) or 0)
  data["invoice"]["vat"] = ((format_price(total_vat) if total_vat) or 0)
  data["invoice"]["discounted"] = (data["invoice"]["discounted"] or false)
  data["invoice"]["discount"] = ((format_price(total_discount) if total_discount) or 0)
  data["invoice"]["total"] = format_price((total_work or 0) + (total_vat or 0))
end

data["work"] = data["work"].map do |w|
  w["value"] = format_price(w["value"])
  w
end if data["work"]

puts Liquid::Template.parse(template).render(data) if template
