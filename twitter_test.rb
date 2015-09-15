#!/usr/bin/env ruby

require 'tweetstream'

$words = {}
$word_count = 0
$time = 0

TweetStream.configure do |config|
  config.consumer_key       = ''
  config.consumer_secret    = ''
  config.oauth_token        = ''
  config.oauth_token_secret = ''
  config.auth_method        = :oauth
end

class Tweets

  def stop_words #get stop words from a text file
    stop_words = []
    stop_words_hash = {}

    File.open("stop_words.txt", "r") do |f|
      f.each_line do |line|
        stop_words.push(line.chomp)
      end
    end

    stop_words.each do |word|
      stop_words_hash[word] = true
    end

    return stop_words_hash #created a hash for filtering
  end

  def filter_tweet(tweet) #filter words that don't have a symbol and is not a stop word
    filtered = []

    tweet.each do |word|
      if !stop_words()[word] && word.match(/^[a-zA-Z]+$/) != nil
        filtered.push(word)
      end
    end

    filtered.each do |word| #creating a hash to keep track of words and their count
      if $words[word] == nil 
        $words[word] = 1 
      else
        $words[word] =  $words[word]+1
      end
    end

    $word_count = $word_count+filtered.count #adding total count of word to global word_count
    return filtered
  end

  def most_frequent_words #sorting and getting 10 most frequented words
    sorted_words = $words.sort_by { |word, count| count }

    return sorted_words[sorted_words.count-10..-1].reverse!
  end

  def start_stream
    TweetStream::Client.new.track("apple", "mac") do |status|

      if $time < 300
        tweet = status.text.downcase.split(' ')
        tweet = filter_tweet(tweet)
        sleep 1 
        $time = $time+1 
        puts Time.at($time).utc.strftime("%H:%M:%S")
      else
        puts "word count = #{$word_count}"
        puts "10 most frequent words: "
        puts "-----------------------"
        most_frequent_words().each_with_index do |word, index|
          puts "#{index+1}. (#{word[0]}) was used #{word[1]} times"
        end
        exit
      end
    end
  end

end  

@tweet = Tweets.new
@tweet.start_stream