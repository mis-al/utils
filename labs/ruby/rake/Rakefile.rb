task default: %w[test]

task :test do
  ruby '-e "puts  \"12345\""'
end