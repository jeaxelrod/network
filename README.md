# [Network](http://network-game.herokuapp.com/)

A [React](http://facebook.github.io/react) & [Ruby on Rails](http://rubyonrails.org/) implementation of Network,a connection game published in Sid Sackson's *A Gamut of Games*.

Live version: http://network-game.herokuapp.com

##Features

* [Tutorial](http://network-game.herokuapp.com/tutorial/teams)
* Local play
* Online play
* A computer AI that uses a minimax algorithm with alpha-beta pruning
* A random move generate

## Installation 

    git clone https://github.com/jeaxelrod/network.git
    cd network
    bundle install
    rake db:migrate
    rails s

## Testing

Tests are written in Rspec and Jasmine. To run rspec tests:

    rspec spec/

To run Jasmine tests:

    rake jasmine

Go to [0.0.0.0:8888](http://0.0.0.0:8888). These tests the React components directly.

## TODO

* Fix issues of computer player
* Improve the board evaluation function for the computer player 
* General layout and content issues

