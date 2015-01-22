include Distribution

desc 'Package octodown into self-contained programs'
task :package do
  ['package:linux:x86', 'package:linux:x86_64', 'package:osx'].each do |task|
    fork do
      Rake::Task[task].invoke
      exit
    end

    sleep 0.01
  end

  Process.waitall
end

namespace :package do
  namespace :linux do
    desc 'Package for Linux x86'
    task :x86 do
      Package.create 'linux-x86'
    end

    desc 'Package for Linux x86_64'
    task :x86_64 do
      Package.create 'linux-x86_64'
    end
  end

  desc 'Package for OS X'
  task :osx do
    Package.create 'osx'
  end
end
