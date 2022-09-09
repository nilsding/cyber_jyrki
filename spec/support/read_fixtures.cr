# macro that returns all kinds of available fixtures
#
# e.g. given a fixtures directory structure of:
#   fixtures/fur_affinity/view_1234.html
#   fixtures/fur_affinity/view_5678.html
#   fixtures/some_other_service/foo.json
#
# with no args the following will be printed:
#   FurAffinity
#   SomeOtherService
#
# with the kind passed as argument (e.g. "FurAffinity") the following will be printed
#   view_1234.html\u0001/Users/foxy/src/cyber_jyrki/fixtures/fur_affinity/view_1234.html
#   view_5678.html\u0001/Users/foxy/src/cyber_jyrki/fixtures/fur_affinity/view_5678.html

FIXTURES_PATH = File.expand_path("../fixtures", __DIR__)

if ARGV.empty?
  puts Dir["#{FIXTURES_PATH}/*"].map(&.sub(%r{^#{FIXTURES_PATH}/}, "").camelcase).join('\n')
  exit
end

kind = ARGV.shift.underscore
file_pairs = Dir["#{FIXTURES_PATH}/#{kind}/*"].map do |file_path|
  file_name = file_path.sub(%r{^#{FIXTURES_PATH}/#{kind}/}, "")

  [file_name, file_path].join('\u0001')
end.join('\n')

puts file_pairs
