require 'getoptlong'
parser = GetoptLong.new
parser.set_options(
  ["-l", "--lab", GetoptLong::REQUIRED_ARGUMENT],
  ["-s", "--server", GetoptLong::REQUIRED_ARGUMENT],
  ["-p", "--port", GetoptLong::REQUIRED_ARGUMENT],
  ["-c", "--logger", GetoptLong::REQUIRED_ARGUMENT] 
)

p parser.get
p parser.get