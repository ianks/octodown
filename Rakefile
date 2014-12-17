require 'bundler/gem_tasks'
require 'open-uri'
require 'fileutils'
require 'tempfile'

task :styles do
  begin
    FileUtils.mkdir 'tmp'
    download_deps
    compile_less
  ensure
    FileUtils.remove_dir 'tmp'
  end
end

def download_deps
  host = 'https://raw.githubusercontent.com/atom/'

  deps = {
    'markdown-preview' => 'markdown-preview/master/stylesheets/markdown-preview.less',
    'syntax-variables' => 'template-syntax/master/stylesheets/syntax-variables.less',
    'colors'           => 'template-syntax/master/stylesheets/colors.less'
  }

  deps.each do |k,v|
    File.open("tmp/#{k}.less", 'w') do |out_file|
      open(host + v, 'r') do |in_file|
        out_file << in_file.read
      end
    end
  end
end

def compile_less
  tmp = 'tmp/github.css'
  out_file = 'assets/markdown-preview.css'
  `lessc tmp/markdown-preview.less #{tmp}`

  File.open out_file, 'w' do |file|
    css = File.read(tmp).gsub /markdown-preview/, 'markdown-body'
    file << css
  end
end
