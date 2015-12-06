# Vapebot

This is a little factoid bot created for use in the vaperhangout channel on Freenode.

## Installation

Clone the repository:

```
git clone git@github.com:jaketnotjacob/vapebot
```

Install the dependencies:

    $ bundle install

Initialize the database and tables:

    $ rake db:create

Create the config file:

    $ cp config/config.example.yaml config/config.yaml

## Usage

Run the bot using:

    $ vapebot

## Development

Please follow the development model [A Successful Git branching model (Vincent Driessen)](http://nvie.com/posts/a-successful-git-branching-model/) when working on this project.  We feel that this is the best way to keep the tree nice and tidy for the time being (though we are always open to suggestions!).

Bug reports and pull requests are welcome on GitHub at https://github.com/jakenotjacob/vapebot.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

