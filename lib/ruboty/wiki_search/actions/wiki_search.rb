require 'digest/md5'

module Ruboty
  module WikiSearch
    module Actions
      class WikiSearch < Ruboty::Actions::Base
        def sync
          Ruboty::WikiSearch::GitOperation.sync!
          message.reply('wiki repository synced.')
        rescue => e
          message.reply("wiki repository sync error! #{e}")
        end

        def search
          search_params = search_params(message.match_data[:search_string].strip)
          message.reply('set search text!') and return unless search_params[:text]

          attachments = Ruboty::WikiSearch::GitOperation.search(search_params).each_with_object([]) do |(repo, detail), arr|
            arr << {
              color: "##{Digest::MD5.hexdigest(repo)[0..5]}",
              author_name: repo,
              author_link: detail[:url],
              text: detail[:files].map {|f| "<#{detail[:url]}/#{f}/_edit|:pencil:> <#{detail[:url]}/#{f}|#{f}>" }.join("\n"),
              mrkdwn_in: %w(text),
            }
          end

          message.reply(
            "#{attachments.empty? ? 'No ' : ''}wiki search results: #{search_params[:text]}",
            parse: 'none',
            attachments: attachments,
          )
          puts attachments if ENV['DEBUG']
        rescue => e
          message.reply("wiki search error! #{e}")
        end

        private

        def search_params(string)
          strings = string.gsub(/　/, ' ').split(' ')
          repo = strings.select {|b| b.start_with?('repo:') }.first&.gsub(/^repo:/, '')
          strings.delete("repo:#{repo}")

          {
            repo: repo,
            text: strings.first,
          }
        end
      end
    end
  end
end
