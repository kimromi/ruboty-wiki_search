# Ruboty::WikiSearch

GitHub wiki search for Ruboty.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-wiki_search'
```

## Environment

### `RUBOTY_WIKI_SEARCH_REPOS`

GitHub wiki clone url. ex:`https://github.com/kimromi/ruboty-wiki_search.wiki.git`

In case of private repository or GitHub Enterprise:  
`https://[token]:x-oauth-basic@git.enterprise.domain/organization/repository.wiki.git`

able to specify multiple repositories, separated by commas.

### `RUBOTY_WIKI_SEARCH_DIRECTORY`

GitHub wiki repository cloned directory. ex:`/tmp`

## Usage

```
# search
ruboty search <search_string>
ruboty search repo:<repository> <search_string>

# git clone or pull master branch repository
ruboty sync
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

