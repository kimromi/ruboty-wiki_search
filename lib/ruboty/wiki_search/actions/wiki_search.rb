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
          search_string = message.match_data[:search_string].strip

          attachments = Ruboty::WikiSearch::GitOperation.search(search_string).each_with_object([]) do |(repo, detail), arr|
            arr << {
              color: "##{Digest::MD5.hexdigest(repo)[0..5]}",
              author_name: repo,
              author_link: detail[:url],
              text: detail[:files].map {|f| "<#{detail[:url]}/#{f}/_edit|:pencil:> <#{detail[:url]}/#{f}|#{f}>" }.join("\n"),
              mrkdwn_in: %w(text),
            }
          end

          message.reply(
            "#{attachments.empty? ? 'No ' : ''}wiki search results: #{search_string}",
            parse: 'none',
            attachments: attachments,
          )
        rescue => e
          message.reply("wiki search error! #{e}")
        end
      end
    end
  end
end
