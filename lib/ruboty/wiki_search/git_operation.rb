require 'uri'
require 'git'

module Ruboty
  module WikiSearch
    module GitOperation
      class << self
        def search(text:, repo:nil)
          Dir.glob("#{repos_directory}/**/*.md").each_with_object({}) do |file_path, hash|
            file_name = file_path.split('/').last
            next if %w(Home.md _Sidebar.md).include?(file_name)

            file_repo = file_path.split('/')[-3..-2].join('/')
            file_repo_url = "https://#{file_path.split('/')[-4..-2].join('/')}/wiki"

            next if repo && file_repo !~ /#{repo}/

            if file_name =~ /#{text}/ || !File.readlines(file_path).grep(/#{text}/).empty?
              hash[file_repo] ||= {}
              hash[file_repo][:url] ||= file_repo_url
              hash[file_repo][:files] ||= []
              hash[file_repo][:files] << file_name.gsub(/\.md$/, '')
              hash[file_repo][:files].sort!
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
          ENV['RUBOTY_WIKI_SEARCH_DIRECTORY'] || File.realpath("#{__dir__}/../../../repos")
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
