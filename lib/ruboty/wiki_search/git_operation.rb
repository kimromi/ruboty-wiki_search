require 'uri'
require 'git'

module Ruboty
  module WikiSearch
    module GitOperation
      class << self
        def search(string)
          Dir.glob("#{repos_directory}/**/*.md").each_with_object({}) do |file_path, hash|
            name = file_path.split('/').last
            repo = file_path.split('/')[-3..-2].join('/')
            repo_url = "https://#{file_path.split('/')[-4..-2].join('/')}/wiki"

            if name =~ /#{string}/ || !File.readlines(file_path).grep(/#{string}/).empty?
              hash[repo] ||= {}
              hash[repo][:url] ||= repo_url
              hash[repo][:files] ||= []
              hash[repo][:files] << name.gsub(/\.md$/, '')
            end
          end
        end

        def sync!
          repo_urls.each do |url|
            u = URI.parse(url)
            if cloned?(u)
              git = Git.open(sync_directory(u))
              git.checkout('master')
              git.pull
            else
              Git.clone(url, sync_directory(u))
            end
          end
        end

        def repo_urls
          ENV['RUBOTY_WIKI_SEARCH_REPOS'].split(',')
        end

        def repos_directory
          File.realpath("#{__dir__}/../../../repos")
        end

        def sync_directory(uri)
          "#{repos_directory}/#{uri.host}#{uri.path.gsub(/\.wiki\.git$/, '')}"
        end

        def cloned?(uri)
          dir = sync_directory(uri)
          Dir.exist?(dir) && Git.open(dir)
        rescue ArgumentError
          FileUtils.rm_rf(dir)
          false
        end
      end
    end
  end
end
