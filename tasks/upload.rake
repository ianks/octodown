include Distribution

desc 'Upload tarballs to GitHub'
task :upload do
  ['upload:linux:x86', 'upload:linux:x86_64', 'upload:osx'].each do |task|
    begin
      Release.create Package.new('osx')
    rescue
      puts 'Release already uploaded, continuing...'
    end

    fork do
      Rake::Task[task].invoke
      exit
    end

    sleep 0.01
  end

  Process.waitall
end

namespace :upload do
  namespace :linux do
    desc 'Upload for Linux x86'
    task :x86 do
      Tarball.upload Package.new('x86')
    end

    desc 'Upload for Linux x86_64'
    task :x86_64 do
      Tarball.upload Package.new('x86_64')
    end
  end

  desc 'Upload for OS X'
  task :osx do
    Tarball.upload Package.new('osx')
  end
end
