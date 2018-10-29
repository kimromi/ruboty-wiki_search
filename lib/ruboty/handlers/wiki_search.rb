require 'ruboty/wiki_search/actions/wiki_search'

module Ruboty
  module Handlers
    class WikiSearch < Base
      on(
        /sync/,
        name: 'sync',
        description: 'git clone or git pull wiki repository'
      )

      on(
        /search (?<search_string>.+)/,
        name: 'search',
        description: 'search wiki'
      )

      def sync(message)
        action(message).sync
      end

      def search(message)
        action(message).search
      end

      private

      def action(message)
        Ruboty::WikiSearch::Actions::WikiSearch.new(message)
      end
    end
  end
end
