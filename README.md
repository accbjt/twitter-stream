# Twitter Streaming Code #

Clone down the repository to your local computer

    git clone git@github.com:accbjt/twitter-stream.git twitter_stream
    cd twitter_stream

Make sure to add your twitter authorization keys in the twitter_test.rb file.

    TweetStream.configure do |config|
        config.consumer_key       = ''
        config.consumer_secret    = ''
        config.oauth_token        = ''
        config.oauth_token_secret = ''
        config.auth_method        = :oauth
    end
    
Now you can start the program

    ./twitter_test.rb

You should start seeing a clock counting up to 5 minutes. After 5 minute you will get your results. 10 most frequent words and total word count without stop words.


