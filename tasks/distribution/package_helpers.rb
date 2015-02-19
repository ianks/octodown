module Distribution
  module PackageHelpers
    def curl(file)
      system "curl -L -O --fail --silent #{file}"
    end

    def print_to_console(msg)
      arch = package.arch
      puts "[#{arch}]:" + ' ' * (16 - arch.size) + '=>' + ' ' + msg
    end
  end
end
