Pod::Spec.new do |s|
  s.name             = 'LDOCappedQueue'
  s.version          = '0.7.0'
  s.summary          = "A queue that doesn't grow indefinitely."

  s.description      = <<-DESC
A queue that only holds a maximum number of items and discards the least recently added ones, if new ones are added and the capacity is reached.
                       DESC

  s.homepage         = 'https://github.com/lurado/LDOCappedQueue'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Julian Raschke und Sebastian Ludwig GbR" => "info@lurado.com" }
  s.source           = { :git => 'https://github.com/lurado/LDOCappedQueue.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LDOCappedQueue/Classes/**/*'
end
