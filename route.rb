action = ARGV[0]
route_file = ARGV[1]
gateway = ARGV[2]

blocks = []
File.read(route_file).each_line do |r|
  blocks << r.strip
end

case action
when "add"
  blocks.each do |b|
    cmd = "sudo route -n add #{b} #{gateway}"
    %x[ #{cmd} ]
  end
when "remove"
  blocks.each do |b|
    cmd = "sudo route -n remove #{b}"
    %x[ #{cmd} ]
  end
else
  "invalid action. must be [add,remove]"
end
