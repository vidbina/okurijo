require "liquid"
require "psych"
require "optparse"

CMD = "invoice"
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{CMD} [options]"
end.parse!

def get_file(file)
  if File.exists? file.to_s
    File.read file.to_s
  else
    nil
  end
end

paths = {
  :details   => 'plan.yaml',
  :template  => 'basic.liquid',
}

template = File.read(paths[:template])
data = Psych.load(File.read(paths[:details]))

def get_total(input)
  if input.is_a? Hash
    return get_total(input.values.map { |v| get_total v })
  elsif input.is_a? Array
    return input.inject { |s,x| s + x }
  else
    return input.to_f
  end
  return 0
end

def format_price(value)
  ('%.2f' % value).sub(',', '_').sub('.', ',').sub('_', '.') # dutch
end

output = { 'expenses' => {} }

data['expenses'].each do |k, v|
  expense_total = get_total(v) + get_total(output['expenses'][k]) 
  output['expenses'][k] = {
    'name' => k,
    'cost' => expense_total,
    'details' => []
  }
  output['expenses']['total'] = (output['expenses']['total'] or 0) + expense_total 
end

puts Liquid::Template.parse(template).render(output) if template
