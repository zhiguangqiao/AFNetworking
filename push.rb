require 'cocoapods'

class ForcePush < Pod::Command::Repo::Push
  def validate_podspec_files
    true
  end
end

def push_interface
  spec = Pathname.pwd.children.select { |pn| pn.fnmatch('*Interface.podspec') }.first
  raise '未找到Interface.podspec结尾的podspec文件' if spec.empty?
  push spec
end
  	
def push_impl
  spec = Pathname.pwd.children.select { |pn| pn.extname == '.podspec' && !pn.fnmatch?('*Interface.podspec') }.first
  raise '未找到.podspec结尾的podspec文件' if spec.empty?
  push spec
end

def push(spec)
  ENV['ALL_PROXY'] = 'socks5://proxy.zhenguanyu.com:8080'
  args = [
    'zhenguanyu-ios-specs',
    spec,
    '--allow-warnings',
    '--use-libraries',
    '--use-modular-headers',
    '--skip-import-validation',
    '--verbose'
  ]
  force_push = ForcePush.new(CLAide::ARGV.new(args))
  force_push.validate!
  force_push.run
end

argv = ARGV.first
if argv == nil || argv.empty?
  push_impl
elsif argv == '-a'
  push_interface
  push_impl
elsif argv == '-i'
  push_interface
else
  raise '不支持的参数'
end
