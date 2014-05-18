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
  data["work"] = Psych.load(work)["work"]
  data["description"] = Psych.load(work)["description"]
  data["invoice"] = Psych.load(work)["invoice"]
  data["keywords"] = Psych.load(work)["keywords"]
else
  exit
end

def format_price(value)
  ('%.2f' % value).sub(',', '_').sub('.', ',').sub('_', '.') # dutch
end

vat_rate = data["invoice"]["vat_rate"] or 21
total_work = (data["work"].map { |w| w["value"] }.reduce :+ if data["work"]) or false
total_vat  = (total_work*vat_rate/100 if total_work && vat_rate.is_a?(Numeric)) or 0
data["invoice"]["subtotal"] = ((format_price(total_work) if total_work) or 0)
data["invoice"]["vat"] = ((format_price(total_vat) if total_vat) or 0)
data["invoice"]["total"] = format_price((total_work or 0) + (total_vat or 0))
data["work"] = data["work"].map do |w|
  w["value"] = format_price(w["value"])
  w
end

puts Liquid::Template.parse(template).render(data) if template
